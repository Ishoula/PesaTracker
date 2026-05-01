package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.*;
import service.CategoryService;
import service.CurrencyService;
import service.RecurringExpenseService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/recurring/*")
public class RecurringExpenseController extends HttpServlet {

    private RecurringExpenseService recurringService;
    private CategoryService categoryService;
    private CurrencyService currencyService;

    @Override
    public void init() {
        this.recurringService = new RecurringExpenseService();
        this.categoryService = new CategoryService();
        this.currencyService = new CurrencyService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<RecurringExpense> recurring = recurringService.getRecurringExpensesByUser(user.getId());
        req.setAttribute("recurringExpenses", recurring);
        req.setAttribute("categories", categoryService.getAllCategories());
        req.setAttribute("currencies", currencyService.getAllCurrencies());
        req.getRequestDispatcher("/views/recurring.jsp").forward(req, resp);
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

        if ("/save".equals(action)) {
            try {
                double amount = Double.parseDouble(req.getParameter("amount"));
                String description = req.getParameter("description");
                Long categoryId = Long.parseLong(req.getParameter("categoryId"));
                Long currencyId = Long.parseLong(req.getParameter("currencyId"));
                String intervalStr = req.getParameter("interval");
                LocalDate startDate = LocalDate.parse(req.getParameter("startDate"));
                String endDateStr = req.getParameter("endDate");
                LocalDate endDate = (endDateStr != null && !endDateStr.isEmpty()) ? LocalDate.parse(endDateStr) : null;

                Category category = categoryService.getCategoryById(categoryId);
                Currency currency = currencyService.getCurrencyById(currencyId);
                RecurringExpense.RecurrenceInterval interval = RecurringExpense.RecurrenceInterval.valueOf(intervalStr);

                recurringService.createRecurringExpense(user, amount, description, category, currency, interval, startDate, endDate);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("/toggle".equals(action)) {
            Long id = Long.parseLong(req.getParameter("id"));
            recurringService.toggleRecurringExpense(id);
        } else if ("/delete".equals(action)) {
            Long id = Long.parseLong(req.getParameter("id"));
            recurringService.deleteRecurringExpense(id);
        } else if ("/process".equals(action)) {
            recurringService.processDueRecurringExpenses();
        }

        resp.sendRedirect(req.getContextPath() + "/recurring");
    }
}
