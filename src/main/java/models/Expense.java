package models;

import jakarta.persistence.*;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Table(name = "expenses")
@Inheritance(strategy = InheritanceType.JOINED)
@Cacheable
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public abstract class Expense implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Double amount;

    @Column(nullable = false)
    private LocalDate date;

    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "currency_id")
    private Currency currency;

    // Constructors
    public Expense() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }
    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    public Currency getCurrency() { return currency; }
    public void setCurrency(Currency currency) { this.currency = currency; }
}