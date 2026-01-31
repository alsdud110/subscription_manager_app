import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/app_strings.dart';
import '../models/subscription.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/notification_provider.dart';
import '../services/notification_service.dart';
import '../widgets/banner_ad_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.lightGray,
      appBar: _buildAppBar(context, isDark, languageProvider),
      bottomNavigationBar: const BannerAdWidget(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // 앱 설정 섹션
          _buildSectionHeader(languageProvider.tr('appSettings'), isDark),
          const SizedBox(height: 10),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              _buildSettingsTile(
                icon: Icons.language_rounded,
                iconBgColor: AppColors.purple,
                title: languageProvider.tr('language'),
                value: languageProvider
                    .tr(languageProvider.isKorean ? 'korean' : 'english'),
                isDark: isDark,
                onTap: () =>
                    _showLanguageDialog(context, languageProvider, isDark),
              ),
              _buildSettingsTile(
                icon:
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                iconBgColor: isDark ? AppColors.purpleLight : AppColors.mint,
                title: languageProvider.tr('theme'),
                isDark: isDark,
                trailing: _buildThemeToggle(themeProvider, isDark),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 알림 섹션
          _buildSectionHeader(languageProvider.tr('notifications'), isDark),
          const SizedBox(height: 10),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              _buildSettingsTile(
                icon: Icons.notifications_rounded,
                iconBgColor: AppColors.mint,
                title: languageProvider.tr('enableNotifications'),
                isDark: isDark,
                trailing: _buildNotificationToggle(
                    notificationProvider, languageProvider, isDark, context),
              ),
              if (notificationProvider.isNotificationEnabled) ...[
                _buildSettingsTile(
                  icon: Icons.alarm_rounded,
                  iconBgColor: AppColors.purple,
                  title: languageProvider.tr('notificationTime'),
                  value: _getDaysBeforeText(
                      notificationProvider.daysBeforeNotification,
                      languageProvider),
                  isDark: isDark,
                  onTap: () => _showNotificationTimeDialog(
                      context, notificationProvider, languageProvider, isDark),
                ),
                _buildSettingsTile(
                  icon: Icons.access_time_rounded,
                  iconBgColor: AppColors.purpleLight,
                  title: languageProvider.tr('notificationHour'),
                  value: languageProvider.isKorean
                      ? notificationProvider.getFormattedNotificationTimeKo()
                      : notificationProvider.getFormattedNotificationTime(),
                  isDark: isDark,
                  showBorder: false,
                  onTap: () => _showNotificationHourDialog(
                      context, notificationProvider, languageProvider, isDark),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // 통화 설정 섹션
          _buildSectionHeader(languageProvider.tr('currency'), isDark),
          const SizedBox(height: 10),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              _buildSettingsTile(
                icon: Icons.paid_rounded,
                iconBgColor: AppColors.teal,
                title: languageProvider.tr('baseCurrency'),
                value: currencyProvider.isKrwBase ? 'KRW' : 'USD',
                isDark: isDark,
                onTap: () => _showBaseCurrencyDialog(
                    context, currencyProvider, languageProvider, isDark),
              ),
              _buildSettingsTile(
                icon: Icons.swap_horiz_rounded,
                iconBgColor: AppColors.mint,
                title: languageProvider.tr('exchangeRate'),
                value:
                    '${currencyProvider.exchangeRate.toStringAsFixed(0)} KRW',
                isDark: isDark,
                showBorder: false,
                onTap: () => _showExchangeRateDialog(
                    context, currencyProvider, languageProvider, isDark),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 데이터 관리 섹션
          _buildSectionHeader(languageProvider.tr('dataManagement'), isDark),
          const SizedBox(height: 10),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              _buildSettingsTile(
                icon: Icons.delete_sweep_rounded,
                iconBgColor: const Color(0xFFFF6B6B),
                title: languageProvider.tr('resetAllSubscriptions'),
                value: subscriptionProvider.subscriptionCount > 0
                    ? '${subscriptionProvider.subscriptionCount}${languageProvider.tr('registeredSubscriptions')}'
                    : null,
                isDark: isDark,
                showBorder: false,
                valueColor: AppColors.gray,
                onTap: () => _showResetConfirmDialog(
                    context, subscriptionProvider, languageProvider, isDark),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 앱 정보 섹션
          // _buildSectionHeader(languageProvider.tr('appInfo'), isDark),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8, bottom: 2),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.gray : AppColors.stone,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    String? value,
    required bool isDark,
    Widget? trailing,
    bool showBorder = true,
    Color? valueColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: showBorder
                ? Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.darkOutline.withValues(alpha: 0.5)
                          : AppColors.lightGray,
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              // 아이콘
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconBgColor,
                      iconBgColor.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: iconBgColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: AppColors.white, size: 18),
              ),
              const SizedBox(width: 14),
              // 타이틀
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
              // 값 또는 trailing 위젯
              if (trailing != null)
                trailing
              else if (value != null) ...[
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valueColor ??
                        (isDark ? AppColors.mint : AppColors.teal),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? AppColors.gray : AppColors.stone,
                  size: 20,
                ),
              ] else if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? AppColors.gray : AppColors.stone,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(ThemeProvider themeProvider, bool isDark) {
    return GestureDetector(
      onTap: () => themeProvider.toggleTheme(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [AppColors.purple, AppColors.purpleLight],
                )
              : const LinearGradient(
                  colors: [AppColors.mint, AppColors.teal],
                ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 14,
              color: isDark ? AppColors.purple : AppColors.teal,
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    return AppBar(
      backgroundColor: isDark ? AppColors.black : AppColors.lightGray,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.white : AppColors.black,
            size: 16,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(
        languageProvider.tr('settings'),
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.white : AppColors.black,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  void _showResetConfirmDialog(
    BuildContext context,
    SubscriptionProvider subscriptionProvider,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    if (subscriptionProvider.subscriptionCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(languageProvider.tr('noSubscriptionsToReset')),
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              isDark ? AppColors.darkSurfaceContainer : AppColors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: AppColors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              languageProvider.tr('resetConfirmTitle'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              languageProvider.tr('resetConfirmMessage'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildBottomSheetButton(
                    text: languageProvider.tr('cancel'),
                    isDark: isDark,
                    isDestructive: false,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBottomSheetButton(
                    text: languageProvider.tr('reset'),
                    isDark: isDark,
                    isDestructive: true,
                    onTap: () async {
                      await subscriptionProvider.clearAllSubscriptions();
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(languageProvider.tr('subscriptionsReset')),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetButton({
    required String text,
    required bool isDark,
    required bool isDestructive,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isDestructive
                ? const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  )
                : (isPrimary
                    ? const LinearGradient(
                        colors: [AppColors.mint, AppColors.teal],
                      )
                    : null),
            color: (isDestructive || isPrimary)
                ? null
                : (isDark ? AppColors.darkOutline : AppColors.lightGray),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: (isDestructive || isPrimary)
                    ? AppColors.white
                    : (isDark ? AppColors.white : AppColors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              languageProvider.tr('language'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildSelectionItem(
              title: '한국어',
              subtitle: 'Korean',
              isSelected: languageProvider.isKorean,
              isDark: isDark,
              onTap: () {
                languageProvider.setLanguage(AppStrings.korean);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _buildSelectionItem(
              title: 'English',
              subtitle: '영어',
              isSelected: languageProvider.isEnglish,
              isDark: isDark,
              onTap: () {
                languageProvider.setLanguage(AppStrings.english);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBaseCurrencyDialog(
    BuildContext context,
    CurrencyProvider currencyProvider,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              languageProvider.tr('baseCurrency'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildSelectionItem(
              title: 'KRW',
              subtitle: languageProvider.tr('krwFull'),
              isSelected: currencyProvider.isKrwBase,
              isDark: isDark,
              currencySymbol: '₩',
              onTap: () {
                currencyProvider.setBaseCurrency(Currency.krw);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _buildSelectionItem(
              title: 'USD',
              subtitle: languageProvider.tr('usdFull'),
              isSelected: currencyProvider.isUsdBase,
              isDark: isDark,
              currencySymbol: '\$',
              onTap: () {
                currencyProvider.setBaseCurrency(Currency.usd);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExchangeRateDialog(
    BuildContext context,
    CurrencyProvider currencyProvider,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    final TextEditingController controller = TextEditingController(
      text: currencyProvider.exchangeRate.toStringAsFixed(0),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                languageProvider.tr('exchangeRate'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                languageProvider.tr('exchangeRateDescription'),
                style: const TextStyle(fontSize: 13, color: AppColors.gray),
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkOutline : AppColors.lightGray,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      '1 USD =',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.mint : AppColors.teal,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                    ),
                    Text(
                      'KRW',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final rate = double.tryParse(controller.text);
                      if (rate != null && rate > 0) {
                        currencyProvider.setExchangeRate(rate);
                        Navigator.pop(context);
                      }
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.mint, AppColors.teal],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mint.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          languageProvider.tr('save'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionItem({
    required String title,
    required String subtitle,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
    String? currencySymbol,
  }) {
    final titleColor = isSelected
        ? AppColors.white
        : (isDark ? AppColors.white : AppColors.black);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [AppColors.mint, AppColors.teal],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isSelected
                ? null
                : (isDark ? AppColors.darkOutline : AppColors.lightGray),
            borderRadius: BorderRadius.circular(14),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.mint.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    currencySymbol != null
                        ? Row(
                            children: [
                              Text(
                                currencySymbol,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Apple SD Gothic Neo',
                                  color: titleColor,
                                ),
                              ),
                              Text(
                                ' $title',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: titleColor,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: titleColor,
                            ),
                          ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.white.withValues(alpha: 0.8)
                            : AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 알림 토글 위젯
  Widget _buildNotificationToggle(
    NotificationProvider notificationProvider,
    LanguageProvider languageProvider,
    bool isDark,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () async {
        final newValue = !notificationProvider.isNotificationEnabled;

        if (newValue) {
          // 알림 켤 때 - 권한 확인
          final notificationService = NotificationService();
          await notificationService.initialize();

          final hasPermission = await notificationService.checkPermission();

          if (!hasPermission) {
            // 권한 요청 다이얼로그 표시
            final shouldRequest = await _showPermissionDialog(
                context, languageProvider, isDark);

            if (!shouldRequest) {
              // 사용자가 "나중에" 선택
              return;
            }

            // 실제 권한이 부여되었는지 다시 확인
            final isGranted = await notificationService.checkPermission();
            if (!isGranted) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(languageProvider.tr('notificationPermissionDenied')),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor:
                        isDark ? AppColors.darkSurfaceContainer : AppColors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
              return;
            }
          }

          // 권한 있으면 알림 활성화
          await notificationProvider.setNotificationEnabled(true);

          // 모든 구독에 대해 알림 스케줄링
          final subscriptions =
              Provider.of<SubscriptionProvider>(context, listen: false)
                  .subscriptions;
          await notificationService.rescheduleAllNotifications(
            subscriptions: subscriptions,
            daysBeforePayment: notificationProvider.daysBeforeNotification,
            hour: notificationProvider.notificationHour,
            minute: notificationProvider.notificationMinute,
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(languageProvider.tr('notificationEnabled')),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        } else {
          // 알림 끌 때 - 모든 알림 취소
          await notificationProvider.setNotificationEnabled(false);
          final notificationService = NotificationService();
          await notificationService.cancelAllNotifications();

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(languageProvider.tr('notificationDisabled')),
                behavior: SnackBarBehavior.floating,
                backgroundColor:
                    isDark ? AppColors.darkSurfaceContainer : AppColors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: notificationProvider.isNotificationEnabled
              ? const LinearGradient(
                  colors: [AppColors.mint, AppColors.teal],
                )
              : null,
          color: notificationProvider.isNotificationEnabled
              ? null
              : (isDark ? AppColors.darkOutline : AppColors.mediumGray),
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: notificationProvider.isNotificationEnabled
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              notificationProvider.isNotificationEnabled
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_rounded,
              size: 14,
              color: notificationProvider.isNotificationEnabled
                  ? AppColors.teal
                  : AppColors.gray,
            ),
          ),
        ),
      ),
    );
  }

  // 권한 요청 다이얼로그
  Future<bool> _showPermissionDialog(
    BuildContext context,
    LanguageProvider languageProvider,
    bool isDark,
  ) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.mint, AppColors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mint.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                color: AppColors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              languageProvider.tr('notificationPermissionTitle'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              languageProvider.tr('notificationPermissionMessage'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildBottomSheetButton(
                    text: languageProvider.tr('later'),
                    isDark: isDark,
                    isDestructive: false,
                    onTap: () => Navigator.pop(context, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBottomSheetButton(
                    text: languageProvider.tr('allow'),
                    isDark: isDark,
                    isDestructive: false,
                    isPrimary: true,
                    onTap: () async {
                      final notificationService = NotificationService();
                      final granted =
                          await notificationService.requestPermission();
                      if (context.mounted) {
                        Navigator.pop(context, granted);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return result ?? false;
  }

  // 며칠 전 텍스트 반환
  String _getDaysBeforeText(int days, LanguageProvider languageProvider) {
    switch (days) {
      case 0:
        return languageProvider.tr('onPaymentDay');
      case 1:
        return languageProvider.tr('daysBefore1');
      case 2:
        return languageProvider.tr('daysBefore2');
      case 3:
        return languageProvider.tr('daysBefore3');
      case 5:
        return languageProvider.tr('daysBefore5');
      case 7:
        return languageProvider.tr('daysBefore7');
      default:
        return '${days}${languageProvider.tr('daysBeforePayment')}';
    }
  }

  // 알림 시간 선택 다이얼로그 (몇 일 전)
  void _showNotificationTimeDialog(
    BuildContext context,
    NotificationProvider notificationProvider,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    final options = [
      (0, languageProvider.tr('onPaymentDay')),
      (1, languageProvider.tr('daysBefore1')),
      (2, languageProvider.tr('daysBefore2')),
      (3, languageProvider.tr('daysBefore3')),
      (5, languageProvider.tr('daysBefore5')),
      (7, languageProvider.tr('daysBefore7')),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                languageProvider.tr('selectNotificationTime'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildSelectionItem(
                          title: option.$2,
                          subtitle: '',
                          isSelected:
                              notificationProvider.daysBeforeNotification == option.$1,
                          isDark: isDark,
                          onTap: () async {
                            // async 작업 전에 필요한 데이터 미리 가져오기
                            final subscriptions =
                                Provider.of<SubscriptionProvider>(context,
                                        listen: false)
                                    .subscriptions;

                            await notificationProvider
                                .setDaysBeforeNotification(option.$1);

                            // 알림 재스케줄링
                            if (notificationProvider.isNotificationEnabled) {
                              final notificationService = NotificationService();
                              await notificationService.rescheduleAllNotifications(
                                subscriptions: subscriptions,
                                daysBeforePayment: option.$1,
                                hour: notificationProvider.notificationHour,
                                minute: notificationProvider.notificationMinute,
                              );
                            }

                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      languageProvider.tr('notificationSettingsUpdated')),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColors.teal,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 알림 시간대 선택 다이얼로그
  void _showNotificationHourDialog(
    BuildContext context,
    NotificationProvider notificationProvider,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    DateTime tempTime = DateTime(
      2024,
      1,
      1,
      notificationProvider.notificationHour,
      notificationProvider.notificationMinute,
    );

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      languageProvider.tr('cancel'),
                      style: TextStyle(
                        color: isDark ? AppColors.gray : AppColors.gray,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await notificationProvider.setNotificationTime(
                        tempTime.hour,
                        tempTime.minute,
                      );

                      // 알림 재스케줄링
                      if (notificationProvider.isNotificationEnabled) {
                        final notificationService = NotificationService();
                        final subscriptions =
                            Provider.of<SubscriptionProvider>(context,
                                    listen: false)
                                .subscriptions;
                        await notificationService.rescheduleAllNotifications(
                          subscriptions: subscriptions,
                          daysBeforePayment:
                              notificationProvider.daysBeforeNotification,
                          hour: tempTime.hour,
                          minute: tempTime.minute,
                        );
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(languageProvider
                                .tr('notificationSettingsUpdated')),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      }
                    },
                    child: Text(
                      languageProvider.tr('save'),
                      style: const TextStyle(
                        color: AppColors.purple,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: tempTime,
                use24hFormat: false,
                onDateTimeChanged: (DateTime newTime) {
                  tempTime = newTime;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
