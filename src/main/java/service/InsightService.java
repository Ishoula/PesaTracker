package service;

import models.Expense;
import repository.ExpenseRepository;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

public class InsightService {

    private final ExpenseRepository expenseRepository;

    public InsightService() {
        this.expenseRepository = new ExpenseRepository();
    }

    public Map<String, Object> generateInsights(Long userId) {
        Map<String, Object> insights = new HashMap<>();
        List<Expense> allExpenses = expenseRepository.findByUserId(userId);

        LocalDate now = LocalDate.now();
        int currentMonth = now.getMonthValue();
        int currentYear = now.getYear();
        
        int prevMonth = currentMonth == 1 ? 12 : currentMonth - 1;
        int prevYear = currentMonth == 1 ? currentYear - 1 : currentYear;

        double currentMonthTotal = expenseRepository.getTotalSpendingForMonth(userId, currentMonth, currentYear);
        double prevMonthTotal = expenseRepository.getTotalSpendingForMonth(userId, prevMonth, prevYear);

        Map<String, Double> categoryTotals = new HashMap<>();

        for (Expense e : allExpenses) {
            LocalDate d = e.getDate();
            if (d.getMonthValue() == currentMonth && d.getYear() == currentYear) {
                String catName = e.getCategory() != null ? e.getCategory().getName() : "Uncategorized";
                categoryTotals.put(catName, categoryTotals.getOrDefault(catName, 0.0) + e.getAmount());
            }
        }

        double trendPercentage = 0;
        if (prevMonthTotal > 0) {
            trendPercentage = ((currentMonthTotal - prevMonthTotal) / prevMonthTotal) * 100;
        }

        String highestCategory = "None";
        double highestAmount = 0;
        for (Map.Entry<String, Double> entry : categoryTotals.entrySet()) {
            if (entry.getValue() > highestAmount) {
                highestAmount = entry.getValue();
                highestCategory = entry.getKey();
            }
        }

        List<String> suggestions = new ArrayList<>();
        if (currentMonthTotal > prevMonthTotal && prevMonthTotal > 0) {
            suggestions.add("Your spending is up " + String.format("%.1f", trendPercentage) + "% compared to last month. Try to cut back on non-essential purchases.");
        } else if (prevMonthTotal > 0) {
            suggestions.add("Great job! Your spending is down " + String.format("%.1f", Math.abs(trendPercentage)) + "% compared to last month.");
        }

        if (highestAmount > 0 && currentMonthTotal > 0) {
            double catPercentage = (highestAmount / currentMonthTotal) * 100;
            if (catPercentage > 30) {
                suggestions.add(highestCategory + " takes up " + String.format("%.1f", catPercentage) + "% of your budget. Consider setting a stricter budget for this category.");
            }
        }
        
        if (suggestions.isEmpty()) {
            suggestions.add("Keep logging your expenses to get personalized saving suggestions!");
        }

        insights.put("currentMonthTotal", currentMonthTotal);
        insights.put("prevMonthTotal", prevMonthTotal);
        insights.put("trendPercentage", trendPercentage);
        insights.put("highestCategory", highestCategory);
        insights.put("highestAmount", highestAmount);
        insights.put("suggestions", suggestions);
        insights.put("categoryTotals", categoryTotals);

        return insights;
    }
}