package repository;

import models.Currency;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

import java.util.List;
import java.util.Optional;

public class CurrencyRepository {

    public void save(Currency currency) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(currency);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void update(Currency currency) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(currency);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<Currency> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Currency", Currency.class)
                    .setCacheable(true)
                    .getResultList();
        }
    }

    public Optional<Currency> findByCode(String code) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Currency c WHERE c.code = :code";
            return session.createQuery(hql, Currency.class)
                    .setParameter("code", code)
                    .setCacheable(true)
                    .uniqueResultOptional();
        }
    }

    public Currency findById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Currency.class, id);
        }
    }

    public Currency findDefault() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Currency c WHERE c.isDefault = true";
            return session.createQuery(hql, Currency.class)
                    .setCacheable(true)
                    .uniqueResult();
        }
    }

    public void delete(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Currency currency = session.get(Currency.class, id);
            if (currency != null) {
                session.remove(currency);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
