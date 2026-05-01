package service;

import models.*;
import repository.ExpenseRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class ExpenseService {

    private final ExpenseRepository expenseRepository;

    public ExpenseService() {
        this.expenseRepository = new ExpenseRepository();
    }

    public void addPersonalExpense(User user, Double amount, LocalDate date, String desc,
                                   Category cat, Currency currency, Set<Tag> tags, String occasion) {
        PersonalExpense pe = new PersonalExpense();
        pe.setUser(user);
        pe.setAmount(amount);
        pe.setDate(date);
        pe.setDescription(desc);
        pe.setCategory(cat);
        pe.setCurrency(currency);
        if (tags != null) {
            pe.setTags(tags);
        }
        pe.setOccasion(occasion);
        expenseRepository.save(pe);
    }

    public void addBusinessExpense(User user, Double amount, LocalDate date, String desc,
                                   Category cat, Currency currency, Set<Tag> tags,
                                   String comp, String taxId) {
        BusinessExpense be = new BusinessExpense();
        be.setUser(user);
        be.setAmount(amount);
        be.setDate(date);
        be.setDescription(desc);
        be.setCategory(cat);
        be.setCurrency(currency);
        if (tags != null) {
            be.setTags(tags);
        }
        be.setCompanyName(comp);
        be.setTaxId(taxId);
        expenseRepository.save(be);
    }

    public List<Expense> getExpensesByUser(Long userId) {
        return expenseRepository.findByUserId(userId);
    }

    public List<Expense> getExpensesByDateRange(Long userId, LocalDate start, LocalDate end) {
        return expenseRepository.findByUserIdAndDateRange(userId, start, end);
    }

    public List<Expense> getExpensesByCategory(Long userId, Long categoryId) {
        return expenseRepository.findByUserIdAndCategory(userId, categoryId);
    }

    public List<Expense> searchExpenses(Long userId, String keyword) {
        return expenseRepository.searchByUserIdAndKeyword(userId, keyword);
    }

    public List<Expense> filterByAmountRange(Long userId, Double min, Double max) {
        return expenseRepository.findByUserIdAndAmountRange(userId, min, max);
    }

    public double getTotalSpendingForMonth(Long userId, int month, int year) {
        return expenseRepository.getTotalSpendingForMonth(userId, month, year);
    }

    public Map<String, Double> getCategoryDataForChart(Long userId) {
        List<Object[]> rawData = expenseRepository.getExpenseSummaryByCategory(userId);
        return rawData.stream().collect(Collectors.toMap(
                row -> (String) row[0],
                row -> (Double) row[1]
        ));
    }

    public List<Expense> getAllExpenses(Long userId) {
        return expenseRepository.findByUserId(userId);
    }

    public Expense getExpenseById(Long id) {
        return expenseRepository.findById(id);
    }

    public void deleteExpense(Long id) {
        expenseRepository.delete(id);
    }

    public void updateExpense(Expense expense) {
        expenseRepository.update(expense);
    }
}