import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<Subscription> _subscriptions = [];
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();
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

    // 알림이 활성화되어 있으면 스케줄링
    await _scheduleNotificationForSubscription(subscription);

    notifyListeners();
  }

  Future<void> deleteSubscription(String id) async {
    // 알림 취소
    await _notificationService.cancelNotification(id);

    _subscriptions.removeWhere((sub) => sub.id == id);
    await _storageService.saveSubscriptions(_subscriptions);
    notifyListeners();
  }

  Future<void> clearAllSubscriptions() async {
    // 모든 알림 취소
    await _notificationService.cancelAllNotifications();

    _subscriptions.clear();
    await _storageService.saveSubscriptions(_subscriptions);
    notifyListeners();
  }

  // 구독에 대한 알림 스케줄링 (알림 설정 확인)
  Future<void> _scheduleNotificationForSubscription(
      Subscription subscription) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isNotificationEnabled = prefs.getBool('notification_enabled') ?? false;

      if (!isNotificationEnabled) return;

      final daysBeforeNotification = prefs.getInt('days_before_notification') ?? 1;
      final notificationHour = prefs.getInt('notification_hour') ?? 15;
      final notificationMinute = prefs.getInt('notification_minute') ?? 0;
      final languageCode = prefs.getString('language') ?? 'ko';

      await _notificationService.scheduleNotification(
        subscription: subscription,
        daysBeforePayment: daysBeforeNotification,
        hour: notificationHour,
        minute: notificationMinute,
        languageCode: languageCode,
      );
    } catch (e) {
      print('알림 스케줄링 실패: $e');
    }
  }

  int get subscriptionCount => _subscriptions.length;

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

  // 이번 주에 결제가 있는 구독 목록 반환
  List<Subscription> getWeeklySubscriptions() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final Set<String> addedIds = {};
    final List<Subscription> result = [];

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final subs = getSubscriptionsForDate(date);

      for (var sub in subs) {
        if (!addedIds.contains(sub.id)) {
          addedIds.add(sub.id);
          result.add(sub);
        }
      }
    }

    return result;
  }

  // 특정 월에 결제가 있는 구독 목록 반환
  List<Subscription> getMonthlySubscriptions(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final Set<String> addedIds = {};
    final List<Subscription> result = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final subs = getSubscriptionsForDate(date);

      for (var sub in subs) {
        if (!addedIds.contains(sub.id)) {
          addedIds.add(sub.id);
          result.add(sub);
        }
      }
    }

    return result;
  }

  double getMonthlyTotal(Currency currency) {
    final now = DateTime.now();
    return getMonthlyTotalForMonth(now, currency);
  }

  // 특정 월의 합계 계산
  double getMonthlyTotalForMonth(DateTime month, Currency currency) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    double total = 0.0;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
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
