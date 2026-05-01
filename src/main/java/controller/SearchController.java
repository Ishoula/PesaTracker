package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Expense;
import models.User;
import service.ExpenseService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/search/*")
public class SearchController extends HttpServlet {

    private ExpenseService expenseService;

    @Override
    public void init() {
        this.expenseService = new ExpenseService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        String keyword = req.getParameter("keyword");
        String categoryIdStr = req.getParameter("categoryId");
        String minAmountStr = req.getParameter("minAmount");
        String maxAmountStr = req.getParameter("maxAmount");
        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");

        List<Expense> results;

        if (keyword != null && !keyword.trim().isEmpty()) {
            results = expenseService.searchExpenses(user.getId(), keyword);
        } else if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            results = expenseService.getExpensesByCategory(user.getId(), Long.parseLong(categoryIdStr));
        } else if (minAmountStr != null && maxAmountStr != null) {
            double min = Double.parseDouble(minAmountStr);
            double max = Double.parseDouble(maxAmountStr);
            results = expenseService.filterByAmountRange(user.getId(), min, max);
        } else if (startDateStr != null && endDateStr != null && !startDateStr.isEmpty() && !endDateStr.isEmpty()) {
            LocalDate start = LocalDate.parse(startDateStr);
            LocalDate end = LocalDate.parse(endDateStr);
            results = expenseService.getExpensesByDateRange(user.getId(), start, end);
        } else {
            results = expenseService.getAllExpenses(user.getId());
        }

        req.setAttribute("results", results);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("/views/search.jsp").forward(req, resp);
    }
}
