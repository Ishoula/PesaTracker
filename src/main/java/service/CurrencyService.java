package service;

import models.Currency;
import repository.CurrencyRepository;

import java.util.List;
import java.util.Optional;

public class CurrencyService {

    private final CurrencyRepository currencyRepository;

    public CurrencyService() {
        this.currencyRepository = new CurrencyRepository();
    }

    public void createDefaultCurrencies() {
        if (currencyRepository.findAll().isEmpty()) {
            createCurrency("USD", "US Dollar", "$", 1.0, true);
            createCurrency("EUR", "Euro", "€", 1.08, false);
            createCurrency("GBP", "British Pound", "£", 1.26, false);
            createCurrency("JPY", "Japanese Yen", "¥", 0.0067, false);
            createCurrency("KES", "Kenyan Shilling", "KSh", 0.0076, false);
        }
    }

    public Currency createCurrency(String code, String name, String symbol, Double rate, boolean isDefault) {
        Currency currency = new Currency();
        currency.setCode(code);
        currency.setName(name);
        currency.setSymbol(symbol);
        currency.setExchangeRateToUsd(rate);
        currency.setDefault(isDefault);
        currencyRepository.save(currency);
        return currency;
    }

    public List<Currency> getAllCurrencies() {
        return currencyRepository.findAll();
    }

    public Currency getDefaultCurrency() {
        Currency defaultCur = currencyRepository.findDefault();
        if (defaultCur == null) {
            createDefaultCurrencies();
            return currencyRepository.findDefault();
        }
        return defaultCur;
    }

    public Currency getCurrencyByCode(String code) {
        return currencyRepository.findByCode(code).orElse(getDefaultCurrency());
    }

    public Currency getCurrencyById(Long id) {
        return currencyRepository.findById(id);
    }

    public double convertToUsd(double amount, Currency from) {
        return amount * from.getExchangeRateToUsd();
    }

    public double convertFromUsd(double usdAmount, Currency to) {
        return usdAmount / to.getExchangeRateToUsd();
    }
}
