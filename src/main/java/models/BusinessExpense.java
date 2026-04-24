package models;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "business_expenses")
public class BusinessExpense extends Expense {

    private String companyName;
    private String taxId;
    private boolean isReimbursable;

    // Default Constructor
    public BusinessExpense() {
        super();
    }

    // Getters and Setters
    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getTaxId() {
        return taxId;
    }

    public void setTaxId(String taxId) {
        this.taxId = taxId;
    }

    public boolean isReimbursable() {
        return isReimbursable;
    }

    public void setReimbursable(boolean reimbursable) {
        isReimbursable = reimbursable;
    }
}