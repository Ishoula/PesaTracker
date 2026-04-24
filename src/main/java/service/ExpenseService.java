package service;

import models.*;
import repository.ExpenseRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ExpenseService {

    private final ExpenseRepository expenseRepository;

    public ExpenseService() {
        this.expenseRepository = new ExpenseRepository();
    }

    /**
     * FR2: Adds a Personal Expense
     */
    public void addPersonalExpense(Double amount, LocalDate date, String desc, Category cat, String occasion) {
        PersonalExpense pe = new PersonalExpense();
        pe.setAmount(amount);
        pe.setDate(date);
        pe.setDescription(desc);
        pe.setCategory(cat);
        pe.setOccasion(occasion);
        expenseRepository.save(pe);
    }

    /**
     * FR2: Adds a Business Expense
     */
    public void addBusinessExpense(Double amount, LocalDate date, String desc, Category cat, String comp, String taxId) {
        BusinessExpense be = new BusinessExpense();
        be.setAmount(amount);
        be.setDate(date);
        be.setDescription(desc);
        be.setCategory(cat);
        be.setCompanyName(comp);
        be.setTaxId(taxId);
        expenseRepository.save(be);
    }

    /**
     * FR7: Filtering logic using Java Streams (Post-Cache)
     */
    public List<Expense> getExpensesByDateRange(LocalDate start, LocalDate end) {
        return expenseRepository.findAll().stream()
                .filter(e -> !e.getDate().isBefore(start) && !e.getDate().isAfter(end))
                .collect(Collectors.toList());
    }

    /**
     * FR5: Monthly Total Calculation
     */
    public double getTotalSpendingForMonth(int month, int year) {
        return expenseRepository.findAll().stream()
                .filter(e -> e.getDate().getMonthValue() == month && e.getDate().getYear() == year)
                .mapToDouble(Expense::getAmount)
                .sum();
    }

    /**
     * FR6: Data Visualization Helper
     * Transforms raw data into a Map for JFreeChart Pie Charts
     */
    public Map<String, Double> getCategoryDataForChart() {
        List<Object[]> rawData = expenseRepository.getExpenseSummaryByCategory();
        return rawData.stream().collect(Collectors.toMap(
                row -> (String) row[0], // Category Name
                row -> (Double) row[1]  // Sum of Amount
        ));
    }

    public List<Expense> getAllExpenses() {
        return expenseRepository.findAll();
    }

    public void deleteExpense(Long id) {
        expenseRepository.delete(id);
    }
}