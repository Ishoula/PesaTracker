package service;

import models.*;
import repository.ExpenseRepository;
import repository.CategoryRepository;

import jakarta.servlet.http.Part;
import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class ExportImportService {

    private final ExpenseRepository expenseRepository;
    private final CategoryRepository categoryRepository;

    public ExportImportService() {
        this.expenseRepository = new ExpenseRepository();
        this.categoryRepository = new CategoryRepository();
    }

    public String exportToCsv(Long userId, List<Expense> expenses) {
        StringBuilder csv = new StringBuilder();
        csv.append("Date,Description,Amount,Category,Type,Currency\n");

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        for (Expense e : expenses) {
            String type = e instanceof BusinessExpense ? "Business" : "Personal";
            String category = e.getCategory() != null ? e.getCategory().getName() : "Uncategorized";
            String currency = e.getCurrency() != null ? e.getCurrency().getCode() : "USD";

            csv.append(String.format("%s,\"%s\",%.2f,\"%s\",%s,%s\n",
                e.getDate().format(formatter),
                e.getDescription() != null ? e.getDescription().replace("\"", "\"\"") : "",
                e.getAmount(),
                category,
                type,
                currency));
        }

        return csv.toString();
    }

    public String exportToPdf(Long userId, List<Expense> expenses, String title) {
        // Simplified PDF-like HTML export for now
        // For real PDF, Apache PDFBox or OpenPDF library would be needed
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>\n");
        html.append("<html><head><title>").append(title).append("</title>\n");
        html.append("<style>");
        html.append("body{font-family:Arial;margin:40px;}");
        html.append("table{width:100%;border-collapse:collapse;}");
        html.append("th,td{padding:10px;border:1px solid #ddd;text-align:left;}");
        html.append("th{background:#f5f5f5;}");
        html.append(".total{font-weight:bold;font-size:1.2em;margin-top:20px;}");
        html.append("</style></head><body>\n");
        html.append("<h1>").append(title).append("</h1>\n");
        html.append("<table>\n");
        html.append("<tr><th>Date</th><th>Description</th><th>Category</th><th>Type</th><th>Amount</th></tr>\n");

        double total = 0;
        for (Expense e : expenses) {
            String type = e instanceof BusinessExpense ? "Business" : "Personal";
            String category = e.getCategory() != null ? e.getCategory().getName() : "Uncategorized";
            html.append("<tr>")
                .append("<td>").append(e.getDate()).append("</td>")
                .append("<td>").append(e.getDescription() != null ? e.getDescription() : "").append("</td>")
                .append("<td>").append(category).append("</td>")
                .append("<td>").append(type).append("</td>")
                .append("<td>$").append(String.format("%.2f", e.getAmount())).append("</td>")
                .append("</tr>\n");
            total += e.getAmount();
        }

        html.append("</table>\n");
        html.append("<div class='total'>Total: $").append(String.format("%.2f", total)).append("</div>\n");
        html.append("</body></html>");

        return html.toString();
    }

    public int importFromCsv(Long userId, Part filePart, User user, CategoryService categoryService, CurrencyService currencyService) throws IOException {
        int importedCount = 0;
        Currency defaultCurrency = currencyService.getDefaultCurrency();

        try (InputStream is = filePart.getInputStream();
             BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {

            String line;
            boolean isFirstLine = true;
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            while ((line = reader.readLine()) != null) {
                if (isFirstLine) {
                    isFirstLine = false;
                    continue;
                }

                if (line.trim().isEmpty()) continue;

                String[] parts = parseCsvLine(line);
                if (parts.length < 5) continue;

                try {
                    LocalDate date = LocalDate.parse(parts[0].trim(), formatter);
                    String description = parts[1].trim();
                    double amount = Double.parseDouble(parts[2].trim());
                    String categoryName = parts[3].trim();
                    String type = parts.length > 4 ? parts[4].trim() : "Personal";

                    Category category = categoryService.getOrCreateCategory(categoryName);

                    Expense expense;
                    if ("Business".equalsIgnoreCase(type)) {
                        BusinessExpense be = new BusinessExpense();
                        be.setCompanyName("Imported");
                        expense = be;
                    } else {
                        PersonalExpense pe = new PersonalExpense();
                        expense = pe;
                    }

                    expense.setUser(user);
                    expense.setAmount(amount);
                    expense.setDate(date);
                    expense.setDescription(description);
                    expense.setCategory(category);
                    expense.setCurrency(defaultCurrency);

                    expenseRepository.save(expense);
                    importedCount++;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        return importedCount;
    }

    private String[] parseCsvLine(String line) {
        java.util.List<String> result = new java.util.ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inQuotes = false;

        for (char c : line.toCharArray()) {
            if (c == '"') {
                inQuotes = !inQuotes;
            } else if (c == ',' && !inQuotes) {
                result.add(current.toString().trim());
                current = new StringBuilder();
            } else {
                current.append(c);
            }
        }
        result.add(current.toString().trim());

        return result.toArray(new String[0]);
    }
}
