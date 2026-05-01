package models;

import jakarta.persistence.*;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import java.io.Serializable;

@Entity
@Table(name = "currencies")
@Cacheable
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Currency implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 3)
    private String code;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String symbol;

    @Column(name = "exchange_rate_to_usd", nullable = false)
    private Double exchangeRateToUsd;

    @Column(name = "is_default")
    private boolean isDefault;

    public Currency() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSymbol() { return symbol; }
    public void setSymbol(String symbol) { this.symbol = symbol; }
    public Double getExchangeRateToUsd() { return exchangeRateToUsd; }
    public void setExchangeRateToUsd(Double exchangeRateToUsd) { this.exchangeRateToUsd = exchangeRateToUsd; }
    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }
}
