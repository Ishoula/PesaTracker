package service;

import models.*;
import repository.RecurringExpenseRepository;
import repository.ExpenseRepository;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class RecurringExpenseService {

    private final RecurringExpenseRepository recurringRepository;
    private final ExpenseRepository expenseRepository;

    public RecurringExpenseService() {
        this.recurringRepository = new RecurringExpenseRepository();
        this.expenseRepository = new ExpenseRepository();
    }

    public void createRecurringExpense(User user, Double amount, String description,
                                     Category category, Currency currency,
                                     RecurringExpense.RecurrenceInterval interval,
                                     LocalDate startDate, LocalDate endDate) {
        RecurringExpense re = new RecurringExpense();
        re.setUser(user);
        re.setAmount(amount);
        re.setDescription(description);
        re.setCategory(category);
        re.setCurrency(currency);
        re.setRecurrenceInterval(interval);
        re.setStartDate(startDate);
        re.setEndDate(endDate);
        re.setNextOccurrence(startDate);
        re.setActive(true);
        recurringRepository.save(re);
    }

    public List<RecurringExpense> getRecurringExpensesByUser(Long userId) {
        return recurringRepository.findByUserId(userId);
    }

    public void processDueRecurringExpenses() {
        List<RecurringExpense> dueExpenses = recurringRepository.findAllActive();
        LocalDate today = LocalDate.now();

        for (RecurringExpense re : dueExpenses) {
            while (!re.getNextOccurrence().isAfter(today)) {
                if (re.getEndDate() != null && re.getNextOccurrence().isAfter(re.getEndDate())) {
                    re.setActive(false);
                    break;
                }

                Expense expense = createExpenseFromRecurring(re);
                expenseRepository.save(expense);

                re.setNextOccurrence(calculateNextDate(re.getNextOccurrence(), re.getRecurrenceInterval()));
            }
            recurringRepository.update(re);
        }
    }

    private Expense createExpenseFromRecurring(RecurringExpense re) {
        PersonalExpense expense = new PersonalExpense();
        expense.setUser(re.getUser());
        expense.setAmount(re.getAmount());
        expense.setDate(re.getNextOccurrence());
        expense.setDescription(re.getDescription() + " (Recurring)");
        expense.setCategory(re.getCategory());
        expense.setCurrency(re.getCurrency());
        return expense;
    }

    private LocalDate calculateNextDate(LocalDate current, RecurringExpense.RecurrenceInterval interval) {
        return switch (interval) {
            case DAILY -> current.plusDays(1);
            case WEEKLY -> current.plusWeeks(1);
            case MONTHLY -> current.plusMonths(1);
            case YEARLY -> current.plusYears(1);
        };
    }

    public void toggleRecurringExpense(Long id) {
        RecurringExpense re = recurringRepository.findById(id);
        if (re != null) {
            re.setActive(!re.isActive());
            recurringRepository.update(re);
        }
    }

    public void deleteRecurringExpense(Long id) {
        recurringRepository.delete(id);
    }
}
