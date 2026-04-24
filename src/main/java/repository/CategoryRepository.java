package repository;

import models.Category;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;
import java.util.List;
import java.util.Optional;

public class CategoryRepository {

    /**
     * Persists a new category.
     */
    public void save(Category category) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(category);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Retrieves all categories.
     * Uses Query Caching to avoid hitting PostgreSQL repeatedly.
     */
    public List<Category> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Category", Category.class)
                    .setCacheable(true)
                    .getResultList();
        }
    }

    /**
     * Finds a category by its name using HQL.
     */
    public Optional<Category> findByName(String name) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Category c WHERE c.name = :name";
            Query<Category> query = session.createQuery(hql, Category.class);
            query.setParameter("name", name);
            query.setCacheable(true);

            return query.uniqueResultOptional();
        }
    }

    /**
     * Standard ID lookup.
     * Hibernate's session.get() checks the Second-Level Cache automatically.
     */
    public Category findById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Category.class, id);
        }
    }

    /**
     * Deletes a category.
     * Note: Depending on Cascade settings, this may affect linked expenses.
     */
    public void delete(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Category category = session.get(Category.class, id);
            if (category != null) {
                session.remove(category);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}