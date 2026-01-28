import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../services/storage_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<Subscription> _subscriptions = [];
  final StorageService _storageService = StorageService();
  bool _isLoading = true;

  List<Subscription> get subscriptions => _subscriptions;
  bool get isLoading => _isLoading;

  SubscriptionProvider() {
    loadSubscriptions();
  }

  Future<void> loadSubscriptions() async {
    _isLoading = true;
    notifyListeners();
    
    _subscriptions = await _storageService.loadSubscriptions();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addSubscription(Subscription subscription) async {
    _subscriptions.add(subscription);
    await _storageService.saveSubscriptions(_subscriptions);
    notifyListeners();
  }

  Future<void> deleteSubscription(String id) async {
    _subscriptions.removeWhere((sub) => sub.id == id);
    await _storageService.saveSubscriptions(_subscriptions);
    notifyListeners();
  }

  List<Subscription> getSubscriptionsForDate(DateTime date) {
    return _subscriptions.where((sub) => sub.occursOnDate(date)).toList();
  }

  List<DateTime> getDatesWithSubscriptions(DateTime month) {
    final dates = <DateTime>[];
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      if (_subscriptions.any((sub) => sub.occursOnDate(date))) {
        dates.add(date);
      }
    }
    
    return dates;
  }

  double getWeeklyTotal(Currency currency) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    double total = 0.0;
    
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final subs = getSubscriptionsForDate(date);
      
      for (var sub in subs) {
        if (sub.currency == currency) {
          total += sub.amount;
        }
      }
    }
    
    return total;
  }

  double getMonthlyTotal(Currency currency) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    double total = 0.0;
    
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(now.year, now.month, day);
      final subs = getSubscriptionsForDate(date);
      
      for (var sub in subs) {
        if (sub.currency == currency) {
          total += sub.amount;
        }
      }
    }
    
    return total;
  }
}
