package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.*;
import service.ExpenseService;
import service.CategoryService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/expenses/*")
public class ExpenseController extends HttpServlet {

    private ExpenseService expenseService;
    private CategoryService categoryService;

    @Override
    public void init() {
        this.expenseService = new ExpenseService();
        this.categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        // Security Check: Ensure user is logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        if (action == null || action.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/expenses/dashboard");
            return;
        }

        switch (action) {
            case "/dashboard" -> showDashboard(req, resp);
            case "/add" -> showAddForm(req, resp);
            case "/report" -> showReports(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();

        switch (action) {
            case "/save" -> handleSaveExpense(req, resp);
            case "/delete" -> handleDeleteExpense(req, resp);
            case "/report" -> showReports(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Fetch all data for the visual reports (FR5 & FR6)
        List<Expense> expenses = expenseService.getAllExpenses();
        Map<String, Double> chartData = expenseService.getCategoryDataForChart();

        // Calculate summary stats
        double totalSpending = expenses.stream().mapToDouble(Expense::getAmount).sum();

        req.setAttribute("expenses", expenses);
        req.setAttribute("chartData", chartData);
        req.setAttribute("totalSpending", totalSpending);

        req.getRequestDispatcher("/views/dashboard.jsp").forward(req, resp);
    }


    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("categories", categoryService.getAllCategories());
        req.getRequestDispatcher("/views/addExpense.jsp").forward(req, resp);
    }


    private void handleSaveExpense(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // 1. Collect Basic Data
            double amount = Double.parseDouble(req.getParameter("amount"));
            LocalDate date = LocalDate.parse(req.getParameter("date"));
            String desc = req.getParameter("description");

            // 2. Handle the "Typed" Category
            String categoryName = req.getParameter("categoryName");
            Category category = categoryService.getOrCreateCategory(categoryName);

            // 3. Polymorphic Logic
            String type = req.getParameter("expenseType");

            if ("BUSINESS".equalsIgnoreCase(type)) {
                String company = req.getParameter("companyName");
                String taxId = req.getParameter("taxId");
                expenseService.addBusinessExpense(amount, date, desc, category, company, taxId);
            } else {
                String occasion = req.getParameter("occasion");
                expenseService.addPersonalExpense(amount, date, desc, category, occasion);
            }

            resp.sendRedirect(req.getContextPath() + "/expenses/dashboard?msg=saved");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/expenses/add?error=invalid_data");
        }
    }

    private void handleDeleteExpense(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            expenseService.deleteExpense(Long.parseLong(idParam));
        }
        resp.sendRedirect(req.getContextPath() + "/expenses/dashboard?msg=deleted");
    }

    private void showReports(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get filter parameters
        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");
        String categoryName = req.getParameter("categoryName");

        List<Expense> filteredExpenses;

        // Logic: If dates are provided, filter. Otherwise, show current month by default.
        if (startDateStr != null && !startDateStr.isEmpty() && endDateStr != null && !endDateStr.isEmpty()) {
            LocalDate start = LocalDate.parse(startDateStr);
            LocalDate end = LocalDate.parse(endDateStr);
            filteredExpenses = expenseService.getExpensesByDateRange(start, end);
        } else {
            // Default to all for now, or use expenseService.getTotalSpendingForMonth for specific logic
            filteredExpenses = expenseService.getAllExpenses();
        }

        // Secondary filter for Category (if provided)
        if (categoryName != null && !categoryName.isEmpty() && !categoryName.equals("All")) {
            filteredExpenses = filteredExpenses.stream()
                    .filter(e -> e.getCategory().getName().equalsIgnoreCase(categoryName))
                    .collect(Collectors.toList());
        }

        // Calculate total for the filtered result
        double reportTotal = filteredExpenses.stream().mapToDouble(Expense::getAmount).sum();

        req.setAttribute("expenses", filteredExpenses);
        req.setAttribute("reportTotal", reportTotal);
        req.setAttribute("categories", categoryService.getAllCategories());

        req.getRequestDispatcher("/views/reports.jsp").forward(req, resp);
    }
}