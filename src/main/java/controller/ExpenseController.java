package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.*;
import service.ExpenseService;
import service.CategoryService;
import service.CurrencyService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/expenses/*")
public class ExpenseController extends HttpServlet {

    private ExpenseService expenseService;
    private CategoryService categoryService;
    private CurrencyService currencyService;

    @Override
    public void init() {
        this.expenseService = new ExpenseService();
        this.categoryService = new CategoryService();
        this.currencyService = new CurrencyService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (action == null || action.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/expenses/dashboard");
            return;
        }

        switch (action) {
            case "/dashboard" -> showDashboard(req, resp, user);
            case "/add" -> showAddForm(req, resp, user);
            case "/report" -> showReports(req, resp, user);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        switch (action) {
            case "/save" -> handleSaveExpense(req, resp, user);
            case "/delete" -> handleDeleteExpense(req, resp, user);
            case "/report" -> showReports(req, resp, user);
            default -> resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        List<Expense> expenses = expenseService.getAllExpenses(user.getId());
        Map<String, Double> chartData = expenseService.getCategoryDataForChart(user.getId());
        double totalSpending = expenses.stream().mapToDouble(Expense::getAmount).sum();

        req.setAttribute("expenses", expenses);
        req.setAttribute("chartData", chartData);
        req.setAttribute("totalSpending", totalSpending);
        req.getRequestDispatcher("/views/dashboard.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        req.setAttribute("categories", categoryService.getAllCategories());
        req.setAttribute("currencies", currencyService.getAllCurrencies());
        req.getRequestDispatcher("/views/addExpense.jsp").forward(req, resp);
    }

    private void handleSaveExpense(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        try {
            double amount = Double.parseDouble(req.getParameter("amount"));
            LocalDate date = LocalDate.parse(req.getParameter("date"));
            String desc = req.getParameter("description");
            String categoryName = req.getParameter("categoryName");
            Category category = categoryService.getOrCreateCategory(categoryName);
            Long currencyId = req.getParameter("currencyId") != null ? Long.parseLong(req.getParameter("currencyId")) : null;
            Currency currency = currencyId != null ? currencyService.getCurrencyById(currencyId) : currencyService.getDefaultCurrency();

            String type = req.getParameter("expenseType");
            if ("BUSINESS".equalsIgnoreCase(type)) {
                String company = req.getParameter("companyName");
                String taxId = req.getParameter("taxId");
                expenseService.addBusinessExpense(user, amount, date, desc, category, currency, company, taxId);
            } else {
                String occasion = req.getParameter("occasion");
                expenseService.addPersonalExpense(user, amount, date, desc, category, currency, occasion);
            }

            resp.sendRedirect(req.getContextPath() + "/expenses/dashboard?msg=saved");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/expenses/add?error=invalid_data");
        }
    }

    private void handleDeleteExpense(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            expenseService.deleteExpense(Long.parseLong(idParam));
        }
        resp.sendRedirect(req.getContextPath() + "/expenses/dashboard?msg=deleted");
    }

    private void showReports(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");
        String categoryName = req.getParameter("categoryName");

        List<Expense> filteredExpenses;

        if (startDateStr != null && !startDateStr.isEmpty() && endDateStr != null && !endDateStr.isEmpty()) {
            LocalDate start = LocalDate.parse(startDateStr);
            LocalDate end = LocalDate.parse(endDateStr);
            filteredExpenses = expenseService.getExpensesByDateRange(user.getId(), start, end);
        } else {
            filteredExpenses = expenseService.getAllExpenses(user.getId());
        }

        if (categoryName != null && !categoryName.isEmpty() && !categoryName.equals("All")) {
            filteredExpenses = filteredExpenses.stream()
                    .filter(e -> e.getCategory() != null && e.getCategory().getName().equalsIgnoreCase(categoryName))
                    .collect(Collectors.toList());
        }

        double reportTotal = filteredExpenses.stream().mapToDouble(Expense::getAmount).sum();
        Map<String, Double> chartData = expenseService.getCategoryDataForChart(user.getId());

        req.setAttribute("chartData", chartData);
        req.setAttribute("expenses", filteredExpenses);
        req.setAttribute("reportTotal", reportTotal);
        req.setAttribute("categories", categoryService.getAllCategories());
        req.getRequestDispatcher("/views/reports.jsp").forward(req, resp);
    }
}