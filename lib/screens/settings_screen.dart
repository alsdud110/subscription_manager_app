import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/app_strings.dart';
import '../models/subscription.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/currency_provider.dart';
import 'add_subscription_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      appBar: _buildAppBar(context, isDark, languageProvider),
      floatingActionButton: _buildFab(context),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          _buildLanguageOption(context, languageProvider, isDark),
          const SizedBox(height: 12),
          _buildThemeOption(context, themeProvider, languageProvider, isDark),
          const SizedBox(height: 12),
          _buildBaseCurrencyOption(context, currencyProvider, languageProvider, isDark),
          const SizedBox(height: 12),
          _buildExchangeRateOption(context, currencyProvider, languageProvider, isDark),
          const SizedBox(height: 32),
          _buildVersionInfo(languageProvider, isDark),
        ],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.mint.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSubscriptionScreen()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
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
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: isDark ? AppColors.white : AppColors.black,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        languageProvider.tr('settings'),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.black,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.darkOutline
              : AppColors.mediumGray,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (isDark ? AppColors.white : AppColors.black)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            color: isDark ? AppColors.white : AppColors.black,
            size: 22,
          ),
        ),
        title: Text(
          languageProvider.tr('theme'),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
        subtitle: Text(
          isDark ? languageProvider.tr('darkMode') : languageProvider.tr('lightMode'),
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.gray : AppColors.gray,
          ),
        ),
        trailing: Switch(
          value: themeProvider.isDarkMode,
          onChanged: (value) => themeProvider.toggleTheme(),
          activeThumbColor: AppColors.mint,
          activeTrackColor: AppColors.mintLight,
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.darkOutline
              : AppColors.mediumGray,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (isDark ? AppColors.white : AppColors.black)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.language_rounded,
            color: isDark ? AppColors.white : AppColors.black,
            size: 22,
          ),
        ),
        title: Text(
          languageProvider.tr('language'),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
        subtitle: Text(
          languageProvider.tr(languageProvider.isKorean ? 'korean' : 'english'),
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.gray : AppColors.gray,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: isDark ? AppColors.gray : AppColors.gray,
        ),
        onTap: () => _showLanguageDialog(context, languageProvider, isDark),
      ),
    );
  }

  Widget _buildBaseCurrencyOption(
    BuildContext context,
    CurrencyProvider currencyProvider,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.darkOutline
              : AppColors.mediumGray,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (isDark ? AppColors.white : AppColors.black)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.attach_money_rounded,
            color: isDark ? AppColors.white : AppColors.black,
            size: 22,
          ),
        ),
        title: Text(
          languageProvider.tr('baseCurrency'),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
        subtitle: Text(
          currencyProvider.isKrwBase
              ? languageProvider.tr('krwFull')
              : languageProvider.tr('usdFull'),
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.gray : AppColors.gray,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: isDark ? AppColors.gray : AppColors.gray,
        ),
        onTap: () => _showBaseCurrencyDialog(context, currencyProvider, languageProvider, isDark),
      ),
    );
  }

  Widget _buildExchangeRateOption(
    BuildContext context,
    CurrencyProvider currencyProvider,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.darkOutline
              : AppColors.mediumGray,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (isDark ? AppColors.white : AppColors.black)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.currency_exchange_rounded,
            color: isDark ? AppColors.white : AppColors.black,
            size: 22,
          ),
        ),
        title: Text(
          languageProvider.tr('exchangeRate'),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
        subtitle: Text(
          '1 USD = ${currencyProvider.exchangeRate.toStringAsFixed(0)} KRW',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.gray : AppColors.gray,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: isDark ? AppColors.gray : AppColors.gray,
        ),
        onTap: () => _showExchangeRateDialog(context, currencyProvider, languageProvider, isDark),
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
              context: context,
              title: '한국어',
              isSelected: languageProvider.isKorean,
              isDark: isDark,
              onTap: () {
                languageProvider.setLanguage(AppStrings.korean);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
              context: context,
              title: languageProvider.tr('krwFull'),
              isSelected: currencyProvider.isKrwBase,
              isDark: isDark,
              onTap: () {
                currencyProvider.setBaseCurrency(Currency.krw);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkOutline : AppColors.mediumGray,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        '1 USD =',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        'KRW',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    languageProvider.tr('save'),
                    style: const TextStyle(
                      fontSize: 16,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.white : AppColors.black)
              : (isDark ? AppColors.darkSurfaceContainer : AppColors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark
                    ? AppColors.darkOutline
                    : AppColors.mediumGray),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
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
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo(LanguageProvider languageProvider, bool isDark) {
    return Center(
      child: Text(
        '${languageProvider.tr('version')} 1.0.0',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.gray.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
