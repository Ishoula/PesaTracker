package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Budget;
import models.Category;
import models.User;
import service.BudgetService;
import service.CategoryService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet({"/budget", "/budget/*"})
public class BudgetController extends HttpServlet {

    private BudgetService budgetService;
    private CategoryService categoryService;

    @Override
    public void init() {
        this.budgetService = new BudgetService();
        this.categoryService = new CategoryService();
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
        int month = now.getMonthValue();
        int year = now.getYear();

        List<Budget> budgets = budgetService.getBudgetsForMonth(user.getId(), month, year);
        List<Category> categories = categoryService.getAllCategories();

        Map<Long, Double> categorySpentMap = new HashMap<>();
        double totalSpent = budgetService.calculateTotalSpentForMonth(user.getId(), month, year);
        
        Budget overallBudget = null;

        for (Budget b : budgets) {
            if (b.getCategory() == null) {
                overallBudget = b;
            } else {
                double spent = budgetService.calculateCategorySpentForMonth(user.getId(), b.getCategory().getId(), month, year);
                categorySpentMap.put(b.getCategory().getId(), spent);
            }
        }

        req.setAttribute("budgets", budgets);
        req.setAttribute("categories", categories);
        req.setAttribute("overallBudget", overallBudget);
        req.setAttribute("totalSpent", totalSpent);
        req.setAttribute("categorySpentMap", categorySpentMap);
        req.setAttribute("currentMonth", month);
        req.setAttribute("currentYear", year);

        req.getRequestDispatcher("/views/budget.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = req.getPathInfo();
        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year = now.getYear();

        try {
            if ("/setOverall".equals(action)) {
                Double amount = Double.parseDouble(req.getParameter("amount"));
                budgetService.setOverallBudget(user, amount, month, year);
            } else if ("/setCategory".equals(action)) {
                Double amount = Double.parseDouble(req.getParameter("amount"));
                Long categoryId = Long.parseLong(req.getParameter("categoryId"));
                budgetService.setCategoryBudget(user, categoryId, amount, month, year);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/budget");
    }
}