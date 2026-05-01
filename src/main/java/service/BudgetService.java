package service;

import models.Budget;
import models.Category;
import models.Expense;
import models.User;
import repository.BudgetRepository;
import repository.CategoryRepository;
import repository.ExpenseRepository;

import java.time.LocalDate;
import java.util.List;

public class BudgetService {
    private final BudgetRepository budgetRepository;
    private final ExpenseRepository expenseRepository;

    public BudgetService() {
        this.budgetRepository = new BudgetRepository();
        this.expenseRepository = new ExpenseRepository();
    }

    public List<Budget> getBudgetsForMonth(Long userId, int month, int year) {
        return budgetRepository.findByUserAndMonthAndYear(userId, month, year);
    }

    public void setOverallBudget(User user, Double amount, int month, int year) {
        Budget budget = budgetRepository.findOverallBudget(user.getId(), month, year);
        if (budget == null) {
            budget = new Budget();
            budget.setUser(user);
            budget.setMonth(month);
            budget.setYear(year);
            budget.setAmount(amount);
            budgetRepository.save(budget);
        } else {
            budget.setAmount(amount);
            budgetRepository.update(budget);
        }
    }

    public void setCategoryBudget(User user, Long categoryId, Double amount, int month, int year) {
        Budget budget = budgetRepository.findByCategory(user.getId(), categoryId, month, year);
        if (budget == null) {
            budget = new Budget();
            budget.setUser(user);
            Category category = new CategoryRepository().findById(categoryId);
            budget.setCategory(category);
            budget.setMonth(month);
            budget.setYear(year);
            budget.setAmount(amount);
            budgetRepository.save(budget);
        } else {
            budget.setAmount(amount);
            budgetRepository.update(budget);
        }
    }

    public double calculateTotalSpentForMonth(Long userId, int month, int year) {
        return expenseRepository.getTotalSpendingForMonth(userId, month, year);
    }
    
    public double calculateCategorySpentForMonth(Long userId, Long categoryId, int month, int year) {
        return expenseRepository.getTotalSpendingByCategoryForMonth(userId, categoryId, month, year);
    }
}