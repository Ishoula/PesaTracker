package repository;

import models.RecurringExpense;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

import java.time.LocalDate;
import java.util.List;

public class RecurringExpenseRepository {

    public void save(RecurringExpense recurringExpense) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(recurringExpense);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void update(RecurringExpense recurringExpense) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(recurringExpense);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public RecurringExpense findById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(RecurringExpense.class, id);
        }
    }

    public List<RecurringExpense> findByUserId(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT re FROM RecurringExpense re JOIN FETCH re.category WHERE re.user.id = :userId ORDER BY re.nextOccurrence";
            return session.createQuery(hql, RecurringExpense.class)
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }

    public List<RecurringExpense> findActiveDueToday(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM RecurringExpense re WHERE re.user.id = :userId AND re.isActive = true AND re.nextOccurrence <= :today";
            return session.createQuery(hql, RecurringExpense.class)
                    .setParameter("userId", userId)
                    .setParameter("today", LocalDate.now())
                    .getResultList();
        }
    }

    public List<RecurringExpense> findAllActive() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM RecurringExpense re WHERE re.isActive = true AND re.nextOccurrence <= :today";
            return session.createQuery(hql, RecurringExpense.class)
                    .setParameter("today", LocalDate.now())
                    .getResultList();
        }
    }

    public void delete(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            RecurringExpense re = session.get(RecurringExpense.class, id);
            if (re != null) {
                session.remove(re);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
