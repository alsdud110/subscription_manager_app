import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../services/storage_service.dart';

class CurrencyProvider extends ChangeNotifier {
  Currency _baseCurrency = Currency.krw; // Default to KRW
  double _exchangeRate = 1450.0; // Default: 1 USD = 1450 KRW
  final StorageService _storageService = StorageService();

  Currency get baseCurrency => _baseCurrency;
  double get exchangeRate => _exchangeRate;

  bool get isKrwBase => _baseCurrency == Currency.krw;
  bool get isUsdBase => _baseCurrency == Currency.usd;

  CurrencyProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final currencyName = await _storageService.loadBaseCurrency();
    _baseCurrency = Currency.values.firstWhere(
      (e) => e.name == currencyName,
      orElse: () => Currency.krw,
    );
    _exchangeRate = await _storageService.loadExchangeRate();
    notifyListeners();
  }

  Future<void> setBaseCurrency(Currency currency) async {
    if (_baseCurrency != currency) {
      _baseCurrency = currency;
      await _storageService.saveBaseCurrency(currency.name);
      notifyListeners();
    }
  }

  Future<void> setExchangeRate(double rate) async {
    if (_exchangeRate != rate && rate > 0) {
      _exchangeRate = rate;
      await _storageService.saveExchangeRate(rate);
      notifyListeners();
    }
  }

  /// Convert amount to base currency
  double convertToBaseCurrency(double amount, Currency fromCurrency) {
    if (fromCurrency == _baseCurrency) {
      return amount;
    }

    if (_baseCurrency == Currency.krw && fromCurrency == Currency.usd) {
      return amount * _exchangeRate; // USD to KRW
    } else if (_baseCurrency == Currency.usd && fromCurrency == Currency.krw) {
      return amount / _exchangeRate; // KRW to USD
    }

    return amount;
  }
}
