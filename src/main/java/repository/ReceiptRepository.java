package repository;

import models.Receipt;
import org.hibernate.Session;
import org.hibernate.Transaction;
import util.HibernateUtil;

import java.util.List;

public class ReceiptRepository {

    public void save(Receipt receipt) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(receipt);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public Receipt findById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Receipt.class, id);
        }
    }

    public Receipt findByExpenseId(Long expenseId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Receipt r WHERE r.expense.id = :expenseId";
            return session.createQuery(hql, Receipt.class)
                    .setParameter("expenseId", expenseId)
                    .uniqueResult();
        }
    }

    public List<Receipt> findByUserId(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Receipt r WHERE r.user.id = :userId ORDER BY r.uploadDate DESC";
            return session.createQuery(hql, Receipt.class)
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }

    public void delete(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Receipt receipt = session.get(Receipt.class, id);
            if (receipt != null) {
                session.remove(receipt);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
