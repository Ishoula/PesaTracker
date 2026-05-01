package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.User;
import service.InsightService;

import java.io.IOException;
import java.util.Map;

@WebServlet({"/insights", "/insights/*"})
public class InsightController extends HttpServlet {

    private InsightService insightService;

    @Override
    public void init() {
        this.insightService = new InsightService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        Map<String, Object> insights = insightService.generateInsights(user.getId());
        req.setAttribute("insights", insights);
        req.getRequestDispatcher("/views/insights.jsp").forward(req, resp);
    }
}