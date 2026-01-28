import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../constants/colors.dart';
import '../constants/app_strings.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildGlassmorphicAppBar(context, isDark, languageProvider),
      body: Container(
        color: isDark ? Colors.black : Colors.white,
        child: FadeTransition(
          opacity: _animationController,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 32),
            children: [
              _buildSectionTitle(languageProvider.tr('appearance'), isDark),
              const SizedBox(height: 16),
              _buildThemeOption(context, themeProvider, languageProvider, isDark),
              const SizedBox(height: 12),
              _buildLanguageOption(context, languageProvider, isDark),
              const SizedBox(height: 32),
              _buildSectionTitle(languageProvider.tr('general'), isDark),
              const SizedBox(height: 16),
              _buildSettingItem(
                context: context,
                icon: Icons.help_outline,
                title: languageProvider.tr('helpSupport'),
                isDark: isDark,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildSettingItem(
                context: context,
                icon: Icons.privacy_tip_outlined,
                title: languageProvider.tr('privacyPolicy'),
                isDark: isDark,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildSettingItem(
                context: context,
                icon: Icons.description_outlined,
                title: languageProvider.tr('termsOfService'),
                isDark: isDark,
                onTap: () {},
              ),
              const SizedBox(height: 32),
              _buildVersionInfo(languageProvider, isDark),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildGlassmorphicAppBar(
    BuildContext context,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.white.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        languageProvider.tr('settings'),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          letterSpacing: 1.2,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.darkPrimary.withOpacity(0.3), AppColors.secondary.withOpacity(0.3)]
                      : [AppColors.primary.withOpacity(0.2), AppColors.secondary.withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
              ),
            ),
            title: Text(
              languageProvider.tr('theme'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              isDark ? languageProvider.tr('darkMode') : languageProvider.tr('lightMode'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
              activeColor: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LanguageProvider languageProvider,
    bool isDark,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.darkTertiary.withOpacity(0.3), AppColors.accent.withOpacity(0.3)]
                      : [AppColors.accent.withOpacity(0.2), AppColors.darkTertiary.withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.language,
                color: isDark ? AppColors.darkTertiary : AppColors.accent,
              ),
            ),
            title: Text(
              languageProvider.tr('language'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              languageProvider.isKorean ? '한국어' : 'English',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            onTap: () => _showLanguageDialog(context, languageProvider, isDark),
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
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.7),
                      ]
                    : [
                        Colors.white.withOpacity(0.95),
                        Colors.white.withOpacity(0.9),
                      ],
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                  width: 2,
                ),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  languageProvider.tr('language'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                _buildLanguageItem(
                  context: context,
                  title: '한국어',
                  isSelected: languageProvider.isKorean,
                  isDark: isDark,
                  onTap: () {
                    languageProvider.setLanguage(AppStrings.korean);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildLanguageItem(
                  context: context,
                  title: 'English',
                  isSelected: languageProvider.isEnglish,
                  isDark: isDark,
                  onTap: () {
                    languageProvider.setLanguage(AppStrings.english);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageItem({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? AppColors.darkPrimary.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.15))
                : (isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                  : Colors.white.withOpacity(isDark ? 0.1 : 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  )
                : null,
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 4,
            ),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo(LanguageProvider languageProvider, bool isDark) {
    return Center(
      child: Text(
        '${languageProvider.tr('version')} 1.0.0',
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
    );
  }
}
