import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription.dart';

class StorageService {
  static const String _subscriptionsKey = 'subscriptions';
  static const String _themeKey = 'isDarkMode';
  static const String _languageKey = 'languageCode';
  static const String _baseCurrencyKey = 'baseCurrency';
  static const String _exchangeRateKey = 'exchangeRate';

  Future<void> saveSubscriptions(List<Subscription> subscriptions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = subscriptions.map((s) => s.toJson()).toList();
    await prefs.setString(_subscriptionsKey, jsonEncode(jsonList));
  }

  Future<List<Subscription>> loadSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_subscriptionsKey);
    
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Subscription.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  Future<bool> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'ko'; // Default to Korean
  }

  // Currency settings
  Future<void> saveBaseCurrency(String currencyName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseCurrencyKey, currencyName);
  }

  Future<String> loadBaseCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseCurrencyKey) ?? 'krw'; // Default to KRW
  }

  Future<void> saveExchangeRate(double rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_exchangeRateKey, rate);
  }

  Future<double> loadExchangeRate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_exchangeRateKey) ?? 1350.0; // Default: 1 USD = 1350 KRW
  }
}
