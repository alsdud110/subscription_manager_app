import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';
import '../providers/currency_provider.dart';

class SummaryCards extends StatelessWidget {
  final DateTime focusedMonth;

  const SummaryCards({super.key, required this.focusedMonth});

  // 금액 포맷 로직
  String _getFormattedAmount(
      double amount, Currency currency, LanguageProvider lp) {
    final isInteger = amount == amount.toInt();
    final formatter =
        isInteger ? NumberFormat('#,###') : NumberFormat('#,###.##');
    final formattedNumber = formatter.format(amount);

    if (lp.isKorean) {
      final unit = currency == Currency.krw ? '원' : '\$';
      return '$formattedNumber$unit';
    } else {
      final symbol = currency == Currency.krw ? '₩' : '\$';
      return '$symbol$formattedNumber';
    }
  }

  // 결제 주기 번역 로직
  String _getTranslatedBillingInfo(Subscription sub, LanguageProvider lp) {
    if (lp.isKorean) {
      switch (sub.billingCycle) {
        case BillingCycle.once:
          return '1회성: ${sub.month}월 ${sub.dayOfMonth}일';
        case BillingCycle.weekly:
          final days = ['', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
          return '매주 ${days[sub.dayOfWeek ?? 1]}';
        case BillingCycle.monthly:
          return '매월 ${sub.dayOfMonth}일';
        case BillingCycle.yearly:
          return '매년 ${sub.month}월 ${sub.dayOfMonth}일';
      }
    } else {
      return sub.getBillingInfo();
    }
  }

  // 이번 주 월요일 ~ 일요일 날짜 계산기
  String _getWeeklyRangeText(LanguageProvider lp) {
    DateTime now = DateTime.now();
    // 월요일(1)부터 일요일(7)까지 계산
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    DateTime sunday = now.add(Duration(days: 7 - now.weekday));

    String format = "M.dd";
    return "(${DateFormat(format).format(monday)} ~ ${DateFormat(format).format(sunday)})";
  }

  // 선택된 달 텍스트 (예: 1월)
  String _getMonthText(DateTime month, LanguageProvider lp) {
    return lp.isKorean
        ? "(${month.month}월)"
        : "(${DateFormat('MMM').format(month)})";
  }

  // 현재 월인지 확인
  bool _isCurrentMonth(DateTime month) {
    final now = DateTime.now();
    return month.year == now.year && month.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isCurrentMonth = _isCurrentMonth(focusedMonth);

    // 선택된 월의 합계 계산
    final selectedMonthKrw = subscriptionProvider.getMonthlyTotalForMonth(focusedMonth, Currency.krw);
    final selectedMonthUsd = subscriptionProvider.getMonthlyTotalForMonth(focusedMonth, Currency.usd);

    String currencySymbol;
    int decimalDigits;
    double monthlyTotal;

    if (currencyProvider.isKrwBase) {
      monthlyTotal = selectedMonthKrw +
          currencyProvider.convertToBaseCurrency(selectedMonthUsd, Currency.usd);
      currencySymbol = '₩';
      decimalDigits = 0;
    } else {
      monthlyTotal = selectedMonthUsd +
          currencyProvider.convertToBaseCurrency(selectedMonthKrw, Currency.krw);
      currencySymbol = '\$';
      decimalDigits = 2;
    }

    // 현재 월일 때만 주간 합계 계산
    double weeklyTotal = 0;
    if (isCurrentMonth) {
      final weeklyKrw = subscriptionProvider.getWeeklyTotal(Currency.krw);
      final weeklyUsd = subscriptionProvider.getWeeklyTotal(Currency.usd);

      if (currencyProvider.isKrwBase) {
        weeklyTotal = weeklyKrw +
            currencyProvider.convertToBaseCurrency(weeklyUsd, Currency.usd);
      } else {
        weeklyTotal = weeklyUsd +
            currencyProvider.convertToBaseCurrency(weeklyKrw, Currency.krw);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        child: isCurrentMonth
            // 현재 월: 주간 + 월간 카드
            ? Row(
                key: ValueKey('current_${focusedMonth.year}_${focusedMonth.month}'),
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      context: context,
                      title: languageProvider.tr('weeklyTotal').toUpperCase(),
                      subtitle: _getWeeklyRangeText(languageProvider),
                      totalAmount: weeklyTotal,
                      currencySymbol: currencySymbol,
                      decimalDigits: decimalDigits,
                      isDark: isDark,
                      noSubscriptionsText: languageProvider.tr('noSubscriptions'),
                      onTap: () {
                        final weeklySubs = subscriptionProvider.getWeeklySubscriptions();
                        if (weeklySubs.isEmpty) {
                          _showToast(context, languageProvider.tr('noSubscriptions'), isDark);
                        } else {
                          _showDetailSheet(
                            context,
                            "${languageProvider.tr('weeklyTotal')} ${_getWeeklyRangeText(languageProvider)}",
                            weeklySubs,
                            isDark,
                            languageProvider,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      context: context,
                      title: languageProvider.tr('monthlyTotal').toUpperCase(),
                      subtitle: _getMonthText(focusedMonth, languageProvider),
                      totalAmount: monthlyTotal,
                      currencySymbol: currencySymbol,
                      decimalDigits: decimalDigits,
                      isDark: isDark,
                      noSubscriptionsText: languageProvider.tr('noSubscriptions'),
                      onTap: () {
                        final monthlySubs = subscriptionProvider.getMonthlySubscriptions(focusedMonth);
                        if (monthlySubs.isEmpty) {
                          _showToast(context, languageProvider.tr('noSubscriptions'), isDark);
                        } else {
                          _showDetailSheet(
                            context,
                            "${languageProvider.tr('monthlyTotal')} ${_getMonthText(focusedMonth, languageProvider)}",
                            monthlySubs,
                            isDark,
                            languageProvider,
                          );
                        }
                      },
                    ),
                  ),
                ],
              )
            // 다른 월: 해당 월 합계만 (전체 너비)
            : Container(
                key: ValueKey('other_${focusedMonth.year}_${focusedMonth.month}'),
                child: _buildSummaryCard(
                  context: context,
                  title: languageProvider.tr('monthlyTotal').toUpperCase(),
                  subtitle: _getMonthText(focusedMonth, languageProvider),
                  totalAmount: monthlyTotal,
                  currencySymbol: currencySymbol,
                  decimalDigits: decimalDigits,
                  isDark: isDark,
                  noSubscriptionsText: languageProvider.tr('noSubscriptions'),
                  onTap: () {
                    final monthlySubs = subscriptionProvider.getMonthlySubscriptions(focusedMonth);
                    if (monthlySubs.isEmpty) {
                      _showToast(context, languageProvider.tr('noSubscriptions'), isDark);
                    } else {
                      _showDetailSheet(
                        context,
                        "${languageProvider.tr('monthlyTotal')} ${_getMonthText(focusedMonth, languageProvider)}",
                        monthlySubs,
                        isDark,
                        languageProvider,
                      );
                    }
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required double totalAmount,
    required String currencySymbol,
    required int decimalDigits,
    required bool isDark,
    required String noSubscriptionsText,
    required VoidCallback onTap,
  }) {
    final formatter =
        NumberFormat.currency(symbol: '', decimalDigits: decimalDigits);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient:
              isDark ? AppColors.cardGradientDark : AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.gray : Colors.grey[700],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.gray.withOpacity(0.7)
                        : Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (totalAmount > 0)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: currencySymbol,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.white : AppColors.black,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    TextSpan(
                      text: formatter.format(totalAmount),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.white : AppColors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                noSubscriptionsText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray.withOpacity(0.6),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // FAB 버튼과 같은 높이에 토스트 표시
  void _showToast(BuildContext context, String message, bool isDark) {
    final overlay = Overlay.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // 배너 높이(50) + 하단 패딩 + FAB 중심 맞추기
    final toastBottom = 50.0 + bottomPadding + 36.0;

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: toastBottom,
        left: 16,
        right: 80,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceContainer : AppColors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 1500), () {
      overlayEntry.remove();
    });
  }

  // 배경 터치 시 닫히도록 개선된 바텀 시트
  void _showDetailSheet(BuildContext context, String title,
      List<Subscription> subs, bool isDark, LanguageProvider lp) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: GestureDetector(
            onTap: () {}, // 흰 부분 클릭 시는 안닫힘
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.black : AppColors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: AppColors.gray.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 20),
                  Text(title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.black)),
                  const SizedBox(height: 24),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: subs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final sub = subs[index];
                        return Row(
                          children: [
                            sub.iconPath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(sub.iconPath!,
                                        width: 40, height: 40),
                                  )
                                : Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color:
                                          Color(sub.colorValue).withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(child: Text(sub.serviceIcon)),
                                  ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sub.serviceName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: isDark
                                            ? AppColors.white
                                            : AppColors.black),
                                  ),
                                  Text(
                                    _getTranslatedBillingInfo(sub, lp),
                                    style: const TextStyle(
                                        fontSize: 12, color: AppColors.gray),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _getFormattedAmount(sub.amount, sub.currency, lp),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.black),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
