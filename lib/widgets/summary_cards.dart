import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../constants/colors.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';

class SummaryCards extends StatefulWidget {
  const SummaryCards({super.key});

  @override
  State<SummaryCards> createState() => _SummaryCardsState();
}

class _SummaryCardsState extends State<SummaryCards> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _weeklySlide;
  late Animation<Offset> _monthlySlide;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _weeklySlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _monthlySlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeIn,
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

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
      child: Column(
        children: [
          SlideTransition(
            position: _weeklySlide,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildFloatingGlassCard(
                context: context,
                title: languageProvider.tr('weeklyTotal'),
                icon: Icons.calendar_view_week,
                krwAmount: weeklyKrw,
                usdAmount: weeklyUsd,
                gradientColors: isDark
                    ? [AppColors.darkPrimary, AppColors.secondary]
                    : [AppColors.primary, AppColors.secondary],
                glowColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                noSubscriptionsText: languageProvider.tr('noSubscriptions'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SlideTransition(
            position: _monthlySlide,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildFloatingGlassCard(
                context: context,
                title: languageProvider.tr('monthlyTotal'),
                icon: Icons.calendar_month,
                krwAmount: monthlyKrw,
                usdAmount: monthlyUsd,
                gradientColors: isDark
                    ? [AppColors.darkTertiary, AppColors.accent]
                    : [AppColors.accent, AppColors.darkTertiary],
                glowColor: isDark ? AppColors.darkTertiary : AppColors.accent,
                noSubscriptionsText: languageProvider.tr('noSubscriptions'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingGlassCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required double krwAmount,
    required double usdAmount,
    required List<Color> gradientColors,
    required Color glowColor,
    required String noSubscriptionsText,
  }) {
    final krwFormatter = NumberFormat.currency(symbol: '₩', decimalDigits: 0);
    final usdFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.03),
                      ]
                    : [
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.4),
                      ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withOpacity(isDark ? 0.1 : 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(isDark ? 0.2 : 0.15),
                  blurRadius: 25,
                  spreadRadius: 3,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _buildGlowingIconContainer(icon, gradientColors, glowColor, isDark),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (krwAmount > 0)
                        _buildAnimatedNumber(
                          amount: krwAmount,
                          formatter: krwFormatter,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          gradientColors: gradientColors,
                        ),
                      if (usdAmount > 0)
                        _buildAnimatedNumber(
                          amount: usdAmount,
                          formatter: usdFormatter,
                          fontSize: krwAmount > 0 ? 16 : 28,
                          fontWeight: krwAmount > 0 ? FontWeight.w600 : FontWeight.bold,
                          gradientColors: krwAmount > 0
                              ? [Colors.grey.shade600, Colors.grey.shade500]
                              : gradientColors,
                        ),
                      if (krwAmount == 0 && usdAmount == 0)
                        Text(
                          noSubscriptionsText,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingIconContainer(
    IconData icon,
    List<Color> gradientColors,
    Color glowColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors.map((c) => c.withOpacity(isDark ? 0.3 : 0.2)).toList(),
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: glowColor.withOpacity(isDark ? 0.4 : 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(isDark ? 0.3 : 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: gradientColors,
        ).createShader(bounds),
        child: Icon(
          icon,
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAnimatedNumber({
    required double amount,
    required NumberFormat formatter,
    required double fontSize,
    required FontWeight fontWeight,
    required List<Color> gradientColors,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: amount),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ).createShader(bounds),
          child: Text(
            formatter.format(value),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.white,
              fontFeatures: const [FontFeature.tabularFigures()],
              letterSpacing: 0.5,
            ),
          ),
        );
      },
    );
  }
}
