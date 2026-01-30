import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';
import '../providers/currency_provider.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final weeklyKrw = subscriptionProvider.getWeeklyTotal(Currency.krw);
    final weeklyUsd = subscriptionProvider.getWeeklyTotal(Currency.usd);
    final monthlyKrw = subscriptionProvider.getMonthlyTotal(Currency.krw);
    final monthlyUsd = subscriptionProvider.getMonthlyTotal(Currency.usd);

    // Convert to base currency
    double weeklyTotal;
    double monthlyTotal;
    String currencySymbol;
    int decimalDigits;

    if (currencyProvider.isKrwBase) {
      weeklyTotal = weeklyKrw + currencyProvider.convertToBaseCurrency(weeklyUsd, Currency.usd);
      monthlyTotal = monthlyKrw + currencyProvider.convertToBaseCurrency(monthlyUsd, Currency.usd);
      currencySymbol = '₩';
      decimalDigits = 0;
    } else {
      weeklyTotal = weeklyUsd + currencyProvider.convertToBaseCurrency(weeklyKrw, Currency.krw);
      monthlyTotal = monthlyUsd + currencyProvider.convertToBaseCurrency(monthlyKrw, Currency.krw);
      currencySymbol = '\$';
      decimalDigits = 2;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              context: context,
              title: languageProvider.tr('weeklyTotal').toUpperCase(),
              icon: Icons.date_range_outlined,
              totalAmount: weeklyTotal,
              currencySymbol: currencySymbol,
              decimalDigits: decimalDigits,
              isDark: isDark,
              noSubscriptionsText: languageProvider.tr('noSubscriptions'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              context: context,
              title: languageProvider.tr('monthlyTotal').toUpperCase(),
              icon: Icons.calendar_month_outlined,
              totalAmount: monthlyTotal,
              currencySymbol: currencySymbol,
              decimalDigits: decimalDigits,
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
    required double totalAmount,
    required String currencySymbol,
    required int decimalDigits,
    required bool isDark,
    required String noSubscriptionsText,
  }) {
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: decimalDigits);

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
                color: AppColors.gray.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }
}
