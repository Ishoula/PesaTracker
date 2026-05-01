package repository;

import models.Budget;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

import java.util.List;

public class BudgetRepository {

    public void save(Budget budget) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(budget);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void update(Budget budget) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(budget);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<Budget> findByUserAndMonthAndYear(Long userId, int month, int year) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT b FROM Budget b LEFT JOIN FETCH b.category WHERE b.user.id = :userId AND b.month = :month AND b.year = :year";
            Query<Budget> query = session.createQuery(hql, Budget.class);
            query.setParameter("userId", userId);
            query.setParameter("month", month);
            query.setParameter("year", year);
            return query.getResultList();
        }
    }

    public Budget findOverallBudget(Long userId, int month, int year) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT b FROM Budget b WHERE b.user.id = :userId AND b.month = :month AND b.year = :year AND b.category IS NULL";
            Query<Budget> query = session.createQuery(hql, Budget.class);
            query.setParameter("userId", userId);
            query.setParameter("month", month);
            query.setParameter("year", year);
            return query.uniqueResult();
        }
    }
    
    public Budget findByCategory(Long userId, Long categoryId, int month, int year) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT b FROM Budget b WHERE b.user.id = :userId AND b.category.id = :categoryId AND b.month = :month AND b.year = :year";
            Query<Budget> query = session.createQuery(hql, Budget.class);
            query.setParameter("userId", userId);
            query.setParameter("categoryId", categoryId);
            query.setParameter("month", month);
            query.setParameter("year", year);
            return query.uniqueResult();
        }
    }

    public void delete(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Budget budget = session.get(Budget.class, id);
            if (budget != null) {
                session.remove(budget);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
