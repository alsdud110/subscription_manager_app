import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final weeklyKrw = subscriptionProvider.getWeeklyTotal(Currency.krw);
    final weeklyUsd = subscriptionProvider.getWeeklyTotal(Currency.usd);
    final monthlyKrw = subscriptionProvider.getMonthlyTotal(Currency.krw);
    final monthlyUsd = subscriptionProvider.getMonthlyTotal(Currency.usd);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              context: context,
              title: 'WEEKLY TOTAL',
              icon: Icons.date_range_outlined,
              krwAmount: weeklyKrw,
              usdAmount: weeklyUsd,
              isDark: isDark,
              noSubscriptionsText: languageProvider.tr('noSubscriptions'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              context: context,
              title: 'MONTHLY TOTAL',
              icon: Icons.calendar_month_outlined,
              krwAmount: monthlyKrw,
              usdAmount: monthlyUsd,
              isDark: isDark,
              noSubscriptionsText: languageProvider.tr('noSubscriptions'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required double krwAmount,
    required double usdAmount,
    required bool isDark,
    required String noSubscriptionsText,
  }) {
    final krwFormatter = NumberFormat.currency(symbol: '₩', decimalDigits: 0);
    final usdFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.cardGradientDark : AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.gray : Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          if (krwAmount > 0 || usdAmount > 0) ...[
            if (krwAmount > 0)
              Text(
                krwFormatter.format(krwAmount),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.black,
                  letterSpacing: -0.5,
                ),
              ),
            if (usdAmount > 0)
              Text(
                usdFormatter.format(usdAmount),
                style: TextStyle(
                  fontSize: krwAmount > 0 ? 14 : 20,
                  fontWeight: krwAmount > 0 ? FontWeight.w500 : FontWeight.w700,
                  color: krwAmount > 0
                      ? (isDark ? AppColors.gray : AppColors.gray)
                      : (isDark ? AppColors.white : AppColors.black),
                  letterSpacing: -0.3,
                ),
              ),
          ] else
            Text(
              noSubscriptionsText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.gray.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }
}
