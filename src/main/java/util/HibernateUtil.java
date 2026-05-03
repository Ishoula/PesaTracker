package util;

import models.*;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {

    private static SessionFactory sessionFactory;

    public static SessionFactory getSessionFactory(){
        if(sessionFactory==null){
            Configuration configuration= new Configuration();
             configuration.addAnnotatedClass(User.class);
             configuration.addAnnotatedClass(Category.class);
             configuration.addAnnotatedClass(Expense.class);
             configuration.addAnnotatedClass(PersonalExpense.class);
             configuration.addAnnotatedClass(BusinessExpense.class);
             configuration.addAnnotatedClass(Budget.class);
             configuration.addAnnotatedClass(Currency.class);
             configuration.addAnnotatedClass(Receipt.class);
             configuration.addAnnotatedClass(RecurringExpense.class);
             configuration.addAnnotatedClass(Notification.class);

            sessionFactory= configuration.buildSessionFactory();
        }

        return sessionFactory;
    }
}