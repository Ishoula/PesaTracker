package service;

import models.*;
import repository.NotificationRepository;
import repository.BudgetRepository;
import repository.ExpenseRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final BudgetRepository budgetRepository;
    private final ExpenseRepository expenseRepository;

    public NotificationService() {
        this.notificationRepository = new NotificationRepository();
        this.budgetRepository = new BudgetRepository();
        this.expenseRepository = new ExpenseRepository();
    }

    public List<Notification> getNotificationsByUser(Long userId) {
        return notificationRepository.findByUserId(userId);
    }

    public List<Notification> getUnreadNotifications(Long userId) {
        return notificationRepository.findUnreadByUserId(userId);
    }

    public long getUnreadCount(Long userId) {
        return notificationRepository.countUnreadByUserId(userId);
    }

    public void markAllRead(Long userId) {
        notificationRepository.markAllReadByUserId(userId);
    }

    public void createNotification(User user, String title, String message, Notification.NotificationType type) {
        Notification notification = new Notification();
        notification.setUser(user);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setNotificationType(type);
        notification.setRead(false);
        notification.setCreatedAt(LocalDateTime.now());
        notificationRepository.save(notification);
    }

    public void checkBudgetAlerts(User user) {
        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year = now.getYear();

        List<Budget> budgets = budgetRepository.findByUserAndMonthAndYear(user.getId(), month, year);
        double totalSpent = expenseRepository.getTotalSpendingForMonth(user.getId(), month, year);

        for (Budget budget : budgets) {
            if (budget.getCategory() == null) {
                checkOverallBudgetAlert(user, budget, totalSpent);
            } else {
                double categorySpent = expenseRepository.getTotalSpendingByCategoryForMonth(
                    user.getId(), budget.getCategory().getId(), month, year);
                checkCategoryBudgetAlert(user, budget, categorySpent);
            }
        }
    }

    private void checkOverallBudgetAlert(User user, Budget budget, double spent) {
        double percentUsed = (spent / budget.getAmount()) * 100;

        if (percentUsed >= 100) {
            createNotification(user, "Budget Exceeded",
                "You have exceeded your overall budget of " + String.format("%.2f", budget.getAmount()) +
                ". Current spending: " + String.format("%.2f", spent),
                Notification.NotificationType.BUDGET_EXCEEDED);
        } else if (percentUsed >= 80) {
            createNotification(user, "Budget Warning",
                "You have used " + String.format("%.1f", percentUsed) +
                "% of your overall budget. Consider reducing expenses.",
                Notification.NotificationType.BUDGET_WARNING);
        }
    }

    private void checkCategoryBudgetAlert(User user, Budget budget, double spent) {
        double percentUsed = (spent / budget.getAmount()) * 100;
        String categoryName = budget.getCategory().getName();

        if (percentUsed >= 100) {
            createNotification(user, "Category Budget Exceeded",
                "You have exceeded your " + categoryName + " budget.",
                Notification.NotificationType.BUDGET_EXCEEDED);
        } else if (percentUsed >= 80) {
            createNotification(user, "Category Budget Warning",
                "You have used " + String.format("%.1f", percentUsed) +
                "% of your " + categoryName + " budget.",
                Notification.NotificationType.BUDGET_WARNING);
        }
    }

    public void checkUnusualSpending(User user) {
        LocalDate now = LocalDate.now();
        double todaySpent = getTodaySpending(user.getId());
        double avgDaily = getAverageDailySpending(user.getId(), now.minusDays(30), now.minusDays(1));

        if (avgDaily > 0 && todaySpent > avgDaily * 2) {
            createNotification(user, "Unusual Spending Detected",
                "Today's spending (" + String.format("%.2f", todaySpent) +
                ") is significantly higher than your daily average (" + String.format("%.2f", avgDaily) + ").",
                Notification.NotificationType.UNUSUAL_SPENDING);
        }
    }

    private double getTodaySpending(Long userId) {
        LocalDate today = LocalDate.now();
        return expenseRepository.findByUserIdAndDateRange(userId, today, today)
                .stream().mapToDouble(Expense::getAmount).sum();
    }

    private double getAverageDailySpending(Long userId, LocalDate start, LocalDate end) {
        List<Expense> expenses = expenseRepository.findByUserIdAndDateRange(userId, start, end);
        if (expenses.isEmpty()) return 0;
        long days = ChronoUnit.DAYS.between(start, end) + 1;
        return expenses.stream().mapToDouble(Expense::getAmount).sum() / days;
    }
}
