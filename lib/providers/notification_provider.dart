import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _daysBeforeNotificationKey = 'days_before_notification';
  static const String _notificationHourKey = 'notification_hour';
  static const String _notificationMinuteKey = 'notification_minute';

  bool _isNotificationEnabled = false;
  int _daysBeforeNotification = 1; // 결제일 몇 일 전에 알림
  int _notificationHour = 15; // 오후 3시
  int _notificationMinute = 0;

  bool get isNotificationEnabled => _isNotificationEnabled;
  int get daysBeforeNotification => _daysBeforeNotification;
  int get notificationHour => _notificationHour;
  int get notificationMinute => _notificationMinute;

  NotificationProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotificationEnabled = prefs.getBool(_notificationEnabledKey) ?? false;
    _daysBeforeNotification = prefs.getInt(_daysBeforeNotificationKey) ?? 1;
    _notificationHour = prefs.getInt(_notificationHourKey) ?? 15;
    _notificationMinute = prefs.getInt(_notificationMinuteKey) ?? 0;
    notifyListeners();
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    _isNotificationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, enabled);
    notifyListeners();
  }

  Future<void> setDaysBeforeNotification(int days) async {
    _daysBeforeNotification = days;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_daysBeforeNotificationKey, days);
    notifyListeners();
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    _notificationHour = hour;
    _notificationMinute = minute;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_notificationHourKey, hour);
    await prefs.setInt(_notificationMinuteKey, minute);
    notifyListeners();
  }

  String getFormattedNotificationTime() {
    final period = _notificationHour >= 12 ? 'PM' : 'AM';
    final hour = _notificationHour > 12
        ? _notificationHour - 12
        : (_notificationHour == 0 ? 12 : _notificationHour);
    final minute = _notificationMinute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String getFormattedNotificationTimeKo() {
    final period = _notificationHour >= 12 ? '오후' : '오전';
    final hour = _notificationHour > 12
        ? _notificationHour - 12
        : (_notificationHour == 0 ? 12 : _notificationHour);
    final minute = _notificationMinute.toString().padLeft(2, '0');
    return '$period $hour:$minute';
  }
}
