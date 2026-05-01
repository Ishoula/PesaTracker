package repository;

import models.Notification;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

import java.util.List;

public class NotificationRepository {

    public void save(Notification notification) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(notification);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void update(Notification notification) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(notification);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<Notification> findByUserId(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Notification n WHERE n.user.id = :userId ORDER BY n.createdAt DESC";
            return session.createQuery(hql, Notification.class)
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }

    public List<Notification> findUnreadByUserId(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Notification n WHERE n.user.id = :userId AND n.isRead = false ORDER BY n.createdAt DESC";
            return session.createQuery(hql, Notification.class)
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }

    public long countUnreadByUserId(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(n) FROM Notification n WHERE n.user.id = :userId AND n.isRead = false";
            return session.createQuery(hql, Long.class)
                    .setParameter("userId", userId)
                    .getSingleResult();
        }
    }

    public void markAllReadByUserId(Long userId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            String hql = "UPDATE Notification n SET n.isRead = true WHERE n.user.id = :userId AND n.isRead = false";
            session.createQuery(hql)
                    .setParameter("userId", userId)
                    .executeUpdate();
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void delete(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Notification notification = session.get(Notification.class, id);
            if (notification != null) {
                session.remove(notification);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
