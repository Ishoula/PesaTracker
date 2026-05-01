package repository;

import models.*;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

import java.time.LocalDate;
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

    public void update(Expense expense) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(expense);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<Expense> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT e FROM Expense e JOIN FETCH e.category LEFT JOIN FETCH e.tags";
            return session.createQuery(hql, Expense.class)
                    .setCacheable(true)
                    .getResultList();
        }
    }

    public List<Expense> findByUserId(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT e FROM Expense e JOIN FETCH e.category LEFT JOIN FETCH e.tags WHERE e.user.id = :userId ORDER BY e.date DESC";
            return session.createQuery(hql, Expense.class)
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }

    public List<Expense> findByUserIdAndDateRange(Long userId, LocalDate start, LocalDate end) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT e FROM Expense e JOIN FETCH e.category LEFT JOIN FETCH e.tags WHERE e.user.id = :userId AND e.date >= :start AND e.date <= :end ORDER BY e.date DESC";
            return session.createQuery(hql, Expense.class)
                    .setParameter("userId", userId)
                    .setParameter("start", start)
                    .setParameter("end", end)
                    .getResultList();
        }
    }

    public List<Expense> findByUserIdAndCategory(Long userId, Long categoryId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT e FROM Expense e JOIN FETCH e.category LEFT JOIN FETCH e.tags WHERE e.user.id = :userId AND e.category.id = :catId ORDER BY e.date DESC";
            return session.createQuery(hql, Expense.class)
                    .setParameter("userId", userId)
                    .setParameter("catId", categoryId)
                    .getResultList();
        }
    }

    public List<Expense> searchByUserIdAndKeyword(Long userId, String keyword) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT e FROM Expense e JOIN FETCH e.category LEFT JOIN FETCH e.tags WHERE e.user.id = :userId AND (LOWER(e.description) LIKE :kw OR LOWER(e.category.name) LIKE :kw) ORDER BY e.date DESC";
            return session.createQuery(hql, Expense.class)
                    .setParameter("userId", userId)
                    .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                    .getResultList();
        }
    }

    public List<Expense> findByUserIdAndAmountRange(Long userId, Double minAmount, Double maxAmount) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT e FROM Expense e JOIN FETCH e.category LEFT JOIN FETCH e.tags WHERE e.user.id = :userId AND e.amount >= :min AND e.amount <= :max ORDER BY e.date DESC";
            return session.createQuery(hql, Expense.class)
                    .setParameter("userId", userId)
                    .setParameter("min", minAmount)
                    .setParameter("max", maxAmount)
                    .getResultList();
        }
    }

    public List<BusinessExpense> findAllBusinessExpenses() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT be FROM BusinessExpense be JOIN FETCH be.category";
            return session.createQuery(hql, BusinessExpense.class)
                    .setCacheable(true)
                    .getResultList();
        }
    }

    public List<Expense> findByCategory(Long categoryId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT e FROM Expense e JOIN FETCH e.category WHERE e.category.id = :catId";
            Query<Expense> query = session.createQuery(hql, Expense.class);
            query.setParameter("catId", categoryId);
            query.setCacheable(true);
            return query.getResultList();
        }
    }

    public List<Object[]> getExpenseSummaryByCategory(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT e.category.name, SUM(e.amount) FROM Expense e WHERE e.user.id = :userId GROUP BY e.category.name";
            return session.createQuery(hql, Object[].class)
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }

    public List<Object[]> getExpenseSummaryByCategory() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT e.category.name, SUM(e.amount) FROM Expense e GROUP BY e.category.name";
            return session.createQuery(hql, Object[].class)
                    .setCacheable(true)
                    .getResultList();
        }
    }

    public double getTotalSpendingForMonth(Long userId, int month, int year) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COALESCE(SUM(e.amount), 0) FROM Expense e WHERE e.user.id = :userId AND MONTH(e.date) = :month AND YEAR(e.date) = :year";
            return session.createQuery(hql, Double.class)
                    .setParameter("userId", userId)
                    .setParameter("month", month)
                    .setParameter("year", year)
                    .getSingleResult();
        }
    }

    public double getTotalSpendingByCategoryForMonth(Long userId, Long categoryId, int month, int year) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COALESCE(SUM(e.amount), 0) FROM Expense e WHERE e.user.id = :userId AND e.category.id = :catId AND MONTH(e.date) = :month AND YEAR(e.date) = :year";
            return session.createQuery(hql, Double.class)
                    .setParameter("userId", userId)
                    .setParameter("catId", categoryId)
                    .setParameter("month", month)
                    .setParameter("year", year)
                    .getSingleResult();
        }
    }

    public List<Object[]> getDailySpendingForMonth(Long userId, int month, int year) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT e.date, SUM(e.amount) FROM Expense e WHERE e.user.id = :userId AND MONTH(e.date) = :month AND YEAR(e.date) = :year GROUP BY e.date ORDER BY e.date";
            return session.createQuery(hql, Object[].class)
                    .setParameter("userId", userId)
                    .setParameter("month", month)
                    .setParameter("year", year)
                    .getResultList();
        }
    }

    public List<Object[]> getWeeklyComparison(Long userId, int month, int year) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT FUNCTION('week', e.date), SUM(e.amount) FROM Expense e WHERE e.user.id = :userId AND MONTH(e.date) = :month AND YEAR(e.date) = :year GROUP BY FUNCTION('week', e.date) ORDER BY FUNCTION('week', e.date)";
            return session.createQuery(hql, Object[].class)
                    .setParameter("userId", userId)
                    .setParameter("month", month)
                    .setParameter("year", year)
                    .getResultList();
        }
    }

    public Expense findById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Expense.class, id);
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