import 'package:intl/intl.dart';

enum BillingCycle { once, weekly, monthly, yearly }

enum Currency { krw, usd }

class Subscription {
  final String id;
  final String serviceName;
  final String serviceIcon;
  final double amount;
  final Currency currency;
  final BillingCycle billingCycle;
  final int? dayOfWeek;
  final int? dayOfMonth;
  final int? month;
  final DateTime createdAt;
  final int colorValue;
  final DateTime? startDate;
  final DateTime? endDate;

  Subscription({
    required this.id,
    required this.serviceName,
    required this.serviceIcon,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    this.dayOfWeek,
    this.dayOfMonth,
    this.month,
    required this.createdAt,
    this.colorValue = 0xFF6C63FF,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'serviceIcon': serviceIcon,
      'amount': amount,
      'currency': currency.name,
      'billingCycle': billingCycle.name,
      'dayOfWeek': dayOfWeek,
      'dayOfMonth': dayOfMonth,
      'month': month,
      'createdAt': createdAt.toIso8601String(),
      'colorValue': colorValue,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      serviceName: json['serviceName'],
      serviceIcon: json['serviceIcon'],
      amount: json['amount'].toDouble(),
      currency: Currency.values.firstWhere((e) => e.name == json['currency']),
      billingCycle: BillingCycle.values.firstWhere((e) => e.name == json['billingCycle']),
      dayOfWeek: json['dayOfWeek'],
      dayOfMonth: json['dayOfMonth'],
      month: json['month'],
      createdAt: DateTime.parse(json['createdAt']),
      colorValue: json['colorValue'] ?? 0xFF6C63FF,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  bool occursOnDate(DateTime date) {
    switch (billingCycle) {
      case BillingCycle.once:
        return month != null &&
               dayOfMonth != null &&
               date.month == month &&
               date.day == dayOfMonth;
      case BillingCycle.weekly:
        return dayOfWeek != null && date.weekday == dayOfWeek;
      case BillingCycle.monthly:
        return dayOfMonth != null && date.day == dayOfMonth;
      case BillingCycle.yearly:
        return month != null &&
               dayOfMonth != null &&
               date.month == month &&
               date.day == dayOfMonth;
    }
  }

  String getFormattedAmount() {
    final formatter = NumberFormat.currency(
      symbol: currency == Currency.krw ? '₩' : '\$',
      decimalDigits: currency == Currency.krw ? 0 : 2,
    );
    return formatter.format(amount);
  }

  String getBillingInfo() {
    switch (billingCycle) {
      case BillingCycle.once:
        final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return 'One-time: ${months[month ?? 1]} ${dayOfMonth}';
      case BillingCycle.weekly:
        final days = ['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        return 'Every ${days[dayOfWeek ?? 1]}';
      case BillingCycle.monthly:
        return 'Every ${dayOfMonth}${_getDaySuffix(dayOfMonth ?? 1)} of the month';
      case BillingCycle.yearly:
        final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return 'Every ${months[month ?? 1]} ${dayOfMonth}';
    }
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
}
