package models;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "personal_expenses")
public class PersonalExpense extends Expense {

    private String occasion; // e.g., Birthday, Vacation

    public String getOccasion() { return occasion; }
    public void setOccasion(String occasion) { this.occasion = occasion; }
}