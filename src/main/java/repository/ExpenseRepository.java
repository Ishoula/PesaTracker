package repository;

import models.*;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

import java.util.List;

public class ExpenseRepository {

    public void save(Expense expense) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(expense);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Updated with JOIN FETCH to prevent LazyInitializationException in the Dashboard.
     * DISTINCT ensures we don't get duplicate expense objects due to the JOIN.
     */
    public List<Expense> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT e FROM Expense e JOIN FETCH e.category";
            return session.createQuery(hql, Expense.class)
                    .setCacheable(true)
                    .getResultList();
        }
    }

    /**
     * Updated with JOIN FETCH for Business Expenses specifically.
     */
    public List<BusinessExpense> findAllBusinessExpenses() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT be FROM BusinessExpense be JOIN FETCH be.category";
            return session.createQuery(hql, BusinessExpense.class)
                    .setCacheable(true)
                    .getResultList();
        }
    }

    /**
     * Filter expenses by Category ID with JOIN FETCH.
     */
    public List<Expense> findByCategory(Long categoryId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT e FROM Expense e JOIN FETCH e.category WHERE e.category.id = :catId";
            Query<Expense> query = session.createQuery(hql, Expense.class);
            query.setParameter("catId", categoryId);
            query.setCacheable(true);
            return query.getResultList();
        }
    }

    /**
     * Aggregation for Chart.js / JFreeChart.
     * Note: We don't use JOIN FETCH here because we are returning a custom Object array,
     * not managed entities.
     */
    public List<Object[]> getExpenseSummaryByCategory() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT e.category.name, SUM(e.amount) FROM Expense e GROUP BY e.category.name";
            return session.createQuery(hql, Object[].class)
                    .setCacheable(true)
                    .getResultList();
        }
    }

    public void delete(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Expense expense = session.get(Expense.class, id);
            if (expense != null) {
                session.remove(expense);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}