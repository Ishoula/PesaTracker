package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Expense;
import models.User;
import service.CategoryService;
import service.CurrencyService;
import service.ExpenseService;
import service.ExportImportService;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/export/*")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 15)
public class ExportController extends HttpServlet {

    private ExportImportService exportService;
    private ExpenseService expenseService;
    private CategoryService categoryService;
    private CurrencyService currencyService;

    @Override
    public void init() {
        this.exportService = new ExportImportService();
        this.expenseService = new ExpenseService();
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

        String format = req.getParameter("format");
        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");

        List<Expense> expenses;
        if (startDateStr != null && endDateStr != null && !startDateStr.isEmpty() && !endDateStr.isEmpty()) {
            LocalDate start = LocalDate.parse(startDateStr);
            LocalDate end = LocalDate.parse(endDateStr);
            expenses = expenseService.getExpensesByDateRange(user.getId(), start, end);
        } else {
            expenses = expenseService.getAllExpenses(user.getId());
        }

        if ("csv".equalsIgnoreCase(format)) {
            resp.setContentType("text/csv");
            resp.setHeader("Content-Disposition", "attachment; filename=expenses_" + LocalDate.now() + ".csv");
            String csv = exportService.exportToCsv(user.getId(), expenses);
            resp.getWriter().write(csv);
        } else if ("pdf".equalsIgnoreCase(format)) {
            resp.setContentType("text/html");
            resp.setHeader("Content-Disposition", "attachment; filename=expenses_" + LocalDate.now() + ".html");
            String html = exportService.exportToPdf(user.getId(), expenses, "Expense Report");
            resp.getWriter().write(html);
        } else {
            req.setAttribute("expenses", expenses);
            req.getRequestDispatcher("/views/export.jsp").forward(req, resp);
        }
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

        if ("/import".equals(action)) {
            Part filePart = req.getPart("csvFile");
            if (filePart != null && filePart.getSize() > 0) {
                int imported = exportService.importFromCsv(user.getId(), filePart, user, categoryService, currencyService);
                req.getSession().setAttribute("importMessage", "Imported " + imported + " expenses successfully.");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/export");
    }
}
