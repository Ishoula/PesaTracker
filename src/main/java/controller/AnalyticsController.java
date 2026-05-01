package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import service.AnalyticsService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;

@WebServlet("/analytics/*")
public class AnalyticsController extends HttpServlet {

    private AnalyticsService analyticsService;

    @Override
    public void init() {
        this.analyticsService = new AnalyticsService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        LocalDate now = LocalDate.now();

        String action = req.getPathInfo();
        if (action == null || action.equals("/")) {
            action = "/dashboard";
        }

        switch (action) {
            case "/dashboard" -> {
                Map<String, Object> weeklyComparison = analyticsService.getWeeklyMonthlyComparison(user.getId(), now.getMonthValue(), now.getYear());
                Map<String, Object> topCategories = analyticsService.getTopCategories(user.getId(), 5);
                Map<String, Object> trends = analyticsService.getSpendingTrends(user.getId(), 6);

                req.setAttribute("weeklyComparison", weeklyComparison);
                req.setAttribute("topCategories", topCategories);
                req.setAttribute("trends", trends);
                req.getRequestDispatcher("/views/analytics.jsp").forward(req, resp);
            }
            case "/calendar" -> {
                int year = req.getParameter("year") != null ? Integer.parseInt(req.getParameter("year")) : now.getYear();
                int month = req.getParameter("month") != null ? Integer.parseInt(req.getParameter("month")) : now.getMonthValue();

                var calendarData = analyticsService.getCalendarData(user.getId(), year, month);
                req.setAttribute("calendarData", calendarData);
                req.setAttribute("currentMonth", month);
                req.setAttribute("currentYear", year);
                req.getRequestDispatcher("/views/calendar.jsp").forward(req, resp);
            }
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
