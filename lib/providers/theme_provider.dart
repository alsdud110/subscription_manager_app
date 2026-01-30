import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final StorageService _storageService = StorageService();

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  static ThemeData get lightTheme => _lightTheme;
  static ThemeData get darkTheme => _darkTheme;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await _storageService.loadThemeMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.saveThemeMode(_isDarkMode);
    notifyListeners();
  }

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Jalnan2',
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.black,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.lightGray,
      onPrimaryContainer: AppColors.black,
      secondary: AppColors.gray,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.lightGray,
      onSecondaryContainer: AppColors.darkGray,
      tertiary: AppColors.darkGray,
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.lightGray,
      onTertiaryContainer: AppColors.black,
      error: AppColors.black,
      onError: AppColors.white,
      errorContainer: AppColors.lightGray,
      onErrorContainer: AppColors.black,
      surface: AppColors.white,
      onSurface: AppColors.black,
      surfaceContainerHighest: AppColors.lightGray,
      onSurfaceVariant: AppColors.gray,
      outline: AppColors.mediumGray,
      outlineVariant: AppColors.lightGray,
      shadow: Color(0x1A000000),
      scrim: AppColors.black,
      inverseSurface: AppColors.black,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.white,
      surfaceTint: AppColors.black,
    ),
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.black, width: 1.5),
      ),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Jalnan2',
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.white,
      onPrimary: AppColors.black,
      primaryContainer: AppColors.darkGray,
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.gray,
      onSecondary: AppColors.black,
      secondaryContainer: AppColors.darkGray,
      onSecondaryContainer: AppColors.lightGray,
      tertiary: AppColors.lightGray,
      onTertiary: AppColors.black,
      tertiaryContainer: AppColors.darkGray,
      onTertiaryContainer: AppColors.white,
      error: AppColors.white,
      onError: AppColors.black,
      errorContainer: AppColors.darkGray,
      onErrorContainer: AppColors.white,
      surface: AppColors.black,
      onSurface: AppColors.white,
      surfaceContainerHighest: AppColors.darkSurfaceContainer,
      onSurfaceVariant: AppColors.gray,
      outline: AppColors.darkGray,
      outlineVariant: AppColors.darkOutlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.white,
      onInverseSurface: AppColors.black,
      inversePrimary: AppColors.black,
      surfaceTint: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.black,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.darkSurfaceContainer,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.white, width: 1.5),
      ),
    ),
  );
}
