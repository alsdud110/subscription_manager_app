import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/app_strings.dart';
import '../models/subscription.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/subscription_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      appBar: _buildAppBar(context, isDark, languageProvider),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildSectionHeader(languageProvider.tr('appSettings'), isDark),
          const SizedBox(height: 8),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              _buildCompactListTile(
                icon: Icons.language_rounded,
                title: languageProvider.tr('language'),
                subtitle: languageProvider
                    .tr(languageProvider.isKorean ? 'korean' : 'english'),
                isDark: isDark,
                onTap: () =>
                    _showLanguageDialog(context, languageProvider, isDark),
              ),
              _buildDivider(isDark),
              _buildCompactListTile(
                icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                title: languageProvider.tr('theme'),
                subtitle: isDark
                    ? languageProvider.tr('darkMode')
                    : languageProvider.tr('lightMode'),
                isDark: isDark,
                trailing: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                    activeThumbColor: AppColors.mint,
                    activeTrackColor: AppColors.mintLight,
                  ),
                ),
              ),
              _buildDivider(isDark),
              _buildCompactListTile(
                icon: Icons.attach_money_rounded,
                title: languageProvider.tr('baseCurrency'),
                subtitle: currencyProvider.isKrwBase
                    ? languageProvider.tr('krwFull')
                    : languageProvider.tr('usdFull'),
                isDark: isDark,
                onTap: () => _showBaseCurrencyDialog(
                    context, currencyProvider, languageProvider, isDark),
              ),
              _buildDivider(isDark),
              _buildCompactListTile(
                icon: Icons.currency_exchange_rounded,
                title: languageProvider.tr('exchangeRate'),
                subtitle:
                    '1 USD = ${currencyProvider.exchangeRate.toStringAsFixed(0)} KRW',
                isDark: isDark,
                onTap: () => _showExchangeRateDialog(
                    context, currencyProvider, languageProvider, isDark),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionHeader(languageProvider.tr('dataManagement'), isDark),
          const SizedBox(height: 8),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              _buildCompactListTile(
                icon: Icons.delete_outline_rounded,
                title: languageProvider.tr('resetAllSubscriptions'),
                subtitle: subscriptionProvider.subscriptionCount > 0
                    ? '${subscriptionProvider.subscriptionCount}${languageProvider.tr('registeredSubscriptions')}'
                    : languageProvider.tr('noSubscriptionsToReset'),
                isDark: isDark,
                iconColor: Colors.red,
                onTap: () => _showResetConfirmDialog(
                    context, subscriptionProvider, languageProvider, isDark),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionHeader(languageProvider.tr('appInfo'), isDark),
          const SizedBox(height: 8),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.gray,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageProvider.tr('fontLicense'),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.white : AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            languageProvider.tr('fontLicenseText'),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.gray,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.gray,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
          width: 1,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 44,
      color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
    );
  }

  Widget _buildCompactListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: (iconColor ?? (isDark ? AppColors.white : AppColors.black))
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                icon,
                color: iconColor ?? (isDark ? AppColors.white : AppColors.black),
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.gray,
                        size: 18,
                      )
                    : const SizedBox.shrink()),
          ],
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
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 48,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: isDark ? AppColors.white : AppColors.black,
          size: 18,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        languageProvider.tr('settings'),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
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
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.black : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              languageProvider.tr('resetConfirmTitle'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              languageProvider.tr('resetConfirmMessage'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.gray,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          isDark ? AppColors.white : AppColors.black,
                      side: BorderSide(
                        color:
                            isDark ? AppColors.darkOutline : AppColors.mediumGray,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      languageProvider.tr('cancel'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await subscriptionProvider.clearAllSubscriptions();
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(languageProvider.tr('subscriptionsReset')),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      languageProvider.tr('reset'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
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
          color: isDark ? AppColors.black : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              languageProvider.tr('language'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildSelectionItem(
              context: context,
              title: '한국어',
              isSelected: languageProvider.isKorean,
              isDark: isDark,
              onTap: () {
                languageProvider.setLanguage(AppStrings.korean);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
            _buildSelectionItem(
              context: context,
              title: 'English',
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
          color: isDark ? AppColors.black : AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              languageProvider.tr('baseCurrency'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildSelectionItem(
              context: context,
              title: languageProvider.tr('krwFull'),
              isSelected: currencyProvider.isKrwBase,
              isDark: isDark,
              onTap: () {
                currencyProvider.setBaseCurrency(Currency.krw);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
            _buildSelectionItem(
              context: context,
              title: languageProvider.tr('usdFull'),
              isSelected: currencyProvider.isUsdBase,
              isDark: isDark,
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
            color: isDark ? AppColors.black : AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                languageProvider.tr('exchangeRate'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                languageProvider.tr('exchangeRateDescription'),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gray,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.lightGray,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        isDark ? AppColors.darkOutline : AppColors.mediumGray,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Text(
                        '1 USD =',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
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
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Text(
                        'KRW',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final rate = double.tryParse(controller.text);
                    if (rate != null && rate > 0) {
                      currencyProvider.setExchangeRate(rate);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.white : AppColors.black,
                    foregroundColor: isDark ? AppColors.black : AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    languageProvider.tr('save'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
    required BuildContext context,
    required String title,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.white : AppColors.black)
              : (isDark ? AppColors.darkSurfaceContainer : AppColors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppColors.darkOutline : AppColors.mediumGray),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppColors.black : AppColors.white)
                    : (isDark ? AppColors.white : AppColors.black),
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                color: isDark ? AppColors.black : AppColors.white,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
