package service;

import models.*;
import repository.ExpenseRepository;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.stream.Collectors;

public class AnalyticsService {

    private final ExpenseRepository expenseRepository;

    public AnalyticsService() {
        this.expenseRepository = new ExpenseRepository();
    }

    public Map<String, Object> getWeeklyMonthlyComparison(Long userId, int month, int year) {
        Map<String, Object> result = new HashMap<>();

        List<Object[]> weeklyData = expenseRepository.getWeeklyComparison(userId, month, year);
        Map<Integer, Double> weeklySpending = new LinkedHashMap<>();
        for (Object[] row : weeklyData) {
            Number weekNum = (Number) row[0];
            Number amount = (Number) row[1];
            weeklySpending.put(weekNum.intValue(), amount.doubleValue());
        }

        LocalDate firstDay = LocalDate.of(year, month, 1);
        LocalDate lastDay = firstDay.withDayOfMonth(firstDay.lengthOfMonth());

        double totalSpent = expenseRepository.getTotalSpendingForMonth(userId, month, year);
        double dailyAverage = totalSpent / firstDay.lengthOfMonth();

        result.put("weeklySpending", weeklySpending);
        result.put("totalSpent", totalSpent);
        result.put("dailyAverage", dailyAverage);
        result.put("numberOfDays", firstDay.lengthOfMonth());

        return result;
    }

    public Map<String, Object> getTopCategories(Long userId, int limit) {
        Map<String, Object> result = new HashMap<>();

        List<Object[]> categoryData = expenseRepository.getExpenseSummaryByCategory(userId);
        List<Map<String, Object>> topCategories = categoryData.stream()
                .map(row -> {
                    Map<String, Object> cat = new HashMap<>();
                    cat.put("name", row[0]);
                    cat.put("total", row[1]);
                    return cat;
                })
                .sorted((a, b) -> ((Double) b.get("total")).compareTo((Double) a.get("total")))
                .limit(limit)
                .collect(Collectors.toList());

        result.put("topCategories", topCategories);

        if (!topCategories.isEmpty()) {
            double highest = (Double) topCategories.get(0).get("total");
            double total = topCategories.stream().mapToDouble(m -> (Double) m.get("total")).sum();
            result.put("highestCategory", topCategories.get(0).get("name"));
            result.put("highestAmount", highest);
            result.put("highestPercentage", total > 0 ? (highest / total) * 100 : 0);
        }

        return result;
    }

    public Map<String, Object> getSpendingTrends(Long userId, int monthsBack) {
        Map<String, Object> result = new HashMap<>();

        LocalDate end = LocalDate.now();
        LocalDate start = end.minusMonths(monthsBack);

        List<Map<String, Object>> monthlyTrends = new ArrayList<>();
        LocalDate current = start;

        while (!current.isAfter(end)) {
            double total = expenseRepository.getTotalSpendingForMonth(
                userId, current.getMonthValue(), current.getYear());

            Map<String, Object> monthData = new HashMap<>();
            monthData.put("month", current.getMonth().toString().substring(0, 3));
            monthData.put("year", current.getYear());
            monthData.put("total", total);
            monthlyTrends.add(monthData);

            current = current.plusMonths(1);
        }

        result.put("monthlyTrends", monthlyTrends);

        if (monthlyTrends.size() >= 3) {
            // Compare last two COMPLETE months (exclude current incomplete month)
            double lastCompleteMonth = (Double) monthlyTrends.get(monthlyTrends.size() - 2).get("total");
            double prevCompleteMonth = (Double) monthlyTrends.get(monthlyTrends.size() - 3).get("total");
            double change = prevCompleteMonth > 0 ? ((lastCompleteMonth - prevCompleteMonth) / prevCompleteMonth) * 100 : 0;
            result.put("monthOverMonthChange", change);
        }

        return result;
    }

    public Map<String, Object> getDayOfWeekAnalysis(Long userId) {
        Map<String, Object> result = new HashMap<>();

        LocalDate end = LocalDate.now();
        LocalDate start = end.minusMonths(3);

        List<Expense> expenses = expenseRepository.findByUserIdAndDateRange(userId, start, end);

        Map<DayOfWeek, Double> dayTotals = new EnumMap<>(DayOfWeek.class);
        Map<DayOfWeek, Integer> dayCounts = new EnumMap<>(DayOfWeek.class);

        for (DayOfWeek dow : DayOfWeek.values()) {
            dayTotals.put(dow, 0.0);
            dayCounts.put(dow, 0);
        }

        for (Expense e : expenses) {
            DayOfWeek dow = e.getDate().getDayOfWeek();
            dayTotals.put(dow, dayTotals.get(dow) + e.getAmount());
            dayCounts.put(dow, dayCounts.get(dow) + 1);
        }

        List<Map<String, Object>> dayAnalysis = new ArrayList<>();
        for (DayOfWeek dow : DayOfWeek.values()) {
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("day", dow.toString().substring(0, 3));
            dayData.put("total", dayTotals.get(dow));
            dayData.put("count", dayCounts.get(dow));
            dayData.put("average", dayCounts.get(dow) > 0 ? dayTotals.get(dow) / dayCounts.get(dow) : 0);
            dayAnalysis.add(dayData);
        }

        result.put("dayOfWeekAnalysis", dayAnalysis);

        DayOfWeek highestSpendingDay = dayTotals.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey).orElse(null);
        result.put("highestSpendingDay", highestSpendingDay != null ? highestSpendingDay.toString() : "N/A");

        return result;
    }

    public List<Map<String, Object>> getCalendarData(Long userId, int year, int month) {
        List<Map<String, Object>> calendarDays = new ArrayList<>();

        LocalDate firstDay = LocalDate.of(year, month, 1);
        int daysInMonth = firstDay.lengthOfMonth();

        LocalDate startOfCalendar = firstDay.with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY));        if (startOfCalendar.isAfter(firstDay)) {
            startOfCalendar = startOfCalendar.minusWeeks(1);
        }

        LocalDate endOfCalendar = firstDay.withDayOfMonth(daysInMonth)
                .with(TemporalAdjusters.nextOrSame(DayOfWeek.SATURDAY));

        LocalDate current = startOfCalendar;
        List<Object[]> dailySpending = expenseRepository.getDailySpendingForMonth(userId, month, year);
        Map<LocalDate, Double> spendingMap = new HashMap<>();
        for (Object[] row : dailySpending) {
            spendingMap.put((LocalDate) row[0], (Double) row[1]);
        }

        while (!current.isAfter(endOfCalendar)) {
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", current);
            dayData.put("dayOfMonth", current.getDayOfMonth());
            dayData.put("isCurrentMonth", current.getMonthValue() == month);
            dayData.put("isToday", current.equals(LocalDate.now()));
            dayData.put("spending", spendingMap.getOrDefault(current, 0.0));
            calendarDays.add(dayData);
            current = current.plusDays(1);
        }

        return calendarDays;
    }
}
