import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../models/subscription.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Timezone 초기화
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    // Android 초기화 설정
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 초기화 설정
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // 알림 탭 시 동작 (나중에 구현)
    // 예: 특정 화면으로 이동
  }

  /// 알림 권한 확인
  Future<bool> checkPermission() async {
    if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    } else if (Platform.isAndroid) {
      // Android 13 이상
      final status = await Permission.notification.status;
      return status.isGranted;
    }
    return false;
  }

  /// 알림 권한 요청
  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    } else if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return false;
  }

  /// 구독에 대한 알림 스케줄링
  Future<void> scheduleNotification({
    required Subscription subscription,
    required int daysBeforePayment,
    required int hour,
    required int minute,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // 다음 결제일 계산
    final nextPaymentDate = _getNextPaymentDate(subscription);
    if (nextPaymentDate == null) return;

    // 알림 날짜 계산 (결제일 N일 전)
    final notificationDate =
        nextPaymentDate.subtract(Duration(days: daysBeforePayment));

    // 알림 시간 설정
    // final scheduledDate = tz.TZDateTime(
    //   tz.local,
    //   notificationDate.year,
    //   notificationDate.month,
    //   notificationDate.day,
    //   hour,
    //   minute,
    // );

    // 테스트용: 10초 후 알림
    final scheduledDate =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    // 과거 시간이면 스케줄링 안 함
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    // 알림 내용 설정
    const androidDetails = AndroidNotificationDetails(
      'subscription_reminders',
      '구독 결제 알림',
      channelDescription: '구독 서비스 결제일을 알려드립니다',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 알림 스케줄링
    final String title;
    final String body;

    if (daysBeforePayment == 0) {
      title = '${subscription.serviceName} 결제일';
      body = '오늘 ${subscription.getFormattedAmount()} 결제됩니다';
    } else {
      title = '${subscription.serviceName} 결제 예정';
      body = '$daysBeforePayment일 후 ${subscription.getFormattedAmount()} 결제됩니다';
    }

    await _notifications.zonedSchedule(
      subscription.id.hashCode, // 구독 ID를 notification ID로 사용
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// 특정 구독의 알림 취소
  Future<void> cancelNotification(String subscriptionId) async {
    await _notifications.cancel(subscriptionId.hashCode);
  }

  /// 모든 알림 취소
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// 다음 결제일 계산
  DateTime? _getNextPaymentDate(Subscription subscription) {
    final now = DateTime.now();
    DateTime? nextDate;

    switch (subscription.billingCycle) {
      case BillingCycle.once:
        // 한 번만 결제
        if (subscription.month != null && subscription.dayOfMonth != null) {
          nextDate =
              DateTime(now.year, subscription.month!, subscription.dayOfMonth!);
          if (nextDate.isBefore(now)) {
            nextDate = DateTime(
                now.year + 1, subscription.month!, subscription.dayOfMonth!);
          }
        }
        break;

      case BillingCycle.weekly:
        // 주간 결제
        if (subscription.dayOfWeek != null) {
          int daysUntilNext = (subscription.dayOfWeek! - now.weekday) % 7;
          if (daysUntilNext == 0) daysUntilNext = 7;
          nextDate = now.add(Duration(days: daysUntilNext));
        }
        break;

      case BillingCycle.monthly:
        // 월간 결제
        if (subscription.dayOfMonth != null) {
          nextDate = DateTime(now.year, now.month, subscription.dayOfMonth!);
          if (nextDate.isBefore(now)) {
            nextDate =
                DateTime(now.year, now.month + 1, subscription.dayOfMonth!);
          }
        }
        break;

      case BillingCycle.yearly:
        // 연간 결제
        if (subscription.month != null && subscription.dayOfMonth != null) {
          nextDate =
              DateTime(now.year, subscription.month!, subscription.dayOfMonth!);
          if (nextDate.isBefore(now)) {
            nextDate = DateTime(
                now.year + 1, subscription.month!, subscription.dayOfMonth!);
          }
        }
        break;
    }

    // 종료일이 있으면 체크
    if (subscription.endDate != null && nextDate != null) {
      if (nextDate.isAfter(subscription.endDate!)) {
        return null;
      }
    }

    return nextDate;
  }

  /// 모든 구독에 대해 알림 재스케줄링
  Future<void> rescheduleAllNotifications({
    required List<Subscription> subscriptions,
    required int daysBeforePayment,
    required int hour,
    required int minute,
  }) async {
    // 기존 알림 모두 취소
    await cancelAllNotifications();

    // 새로운 알림 스케줄링
    for (final subscription in subscriptions) {
      await scheduleNotification(
        subscription: subscription,
        daysBeforePayment: daysBeforePayment,
        hour: hour,
        minute: minute,
      );
    }
  }
}
