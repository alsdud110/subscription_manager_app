import 'package:flutter/material.dart';

/// Pure Black & White Minimal Color Palette
class AppColors {
  AppColors._();

  // Primary - Pure Black
  static const Color primary = Color(0xFF000000);
  static const Color primaryLight = Color(0xFF333333);
  static const Color primaryDark = Color(0xFF000000);

  // Secondary - Gray
  static const Color secondary = Color(0xFF666666);
  static const Color secondaryLight = Color(0xFF999999);
  static const Color secondaryDark = Color(0xFF333333);

  // Accent - Black
  static const Color accent = Color(0xFF000000);
  static const Color accentLight = Color(0xFF333333);
  static const Color accentDark = Color(0xFF000000);

  // Neutrals - Pure grayscale
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE0E0E0);
  static const Color gray = Color(0xFF888888);
  static const Color darkGray = Color(0xFF333333);
  static const Color black = Color(0xFF000000);

  // Light Theme Colors
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainer = Color(0xFFF5F5F5);
  static const Color lightOnSurface = Color(0xFF000000);
  static const Color lightOnSurfaceVariant = Color(0xFF666666);
  static const Color lightOutline = Color(0xFFE0E0E0);
  static const Color lightOutlineVariant = Color(0xFFF0F0F0);

  // Dark Theme Colors
  static const Color darkSurface = Color(0xFF000000);
  static const Color darkSurfaceContainer = Color(0xFF1A1A1A);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkOnSurfaceVariant = Color(0xFF999999);
  static const Color darkOutline = Color(0xFF333333);
  static const Color darkOutlineVariant = Color(0xFF222222);

  // Dark mode primary variants
  static const Color darkPrimary = Color(0xFFFFFFFF);
  static const Color darkSecondary = Color(0xFFCCCCCC);
  static const Color darkAccent = Color(0xFFFFFFFF);

  // Error
  static const Color error = Color(0xFF000000);
  static const Color errorLight = Color(0xFF666666);
  static const Color errorDark = Color(0xFF000000);

  // Legacy aliases for compatibility
  static const Color warmWhite = white;
  static const Color cream = lightGray;
  static const Color sand = mediumGray;
  static const Color stone = gray;
  static const Color charcoal = darkGray;
  static const Color warmBlack = black;

  // 구독 마커 색상 - colorful palette
  static const List<int> subscriptionColors = [
    0xFFFF6B6B, // Coral Red
    0xFFFF8E53, // Orange
    0xFFFFD93D, // Yellow
    0xFF6BCB77, // Green
    0xFF4D96FF, // Blue
    0xFF9B59B6, // Purple
    0xFFE91E63, // Pink
    0xFF00BCD4, // Cyan
    0xFF8D6E63, // Brown
    0xFF607D8B, // Blue Grey
  ];

  // === 그라데이션 색상 (브랜드 컬러) ===

  // 민트/청록 계열
  static const Color mint = Color(0xFF4ECDC4);
  static const Color teal = Color(0xFF2EC4B6);
  static const Color mintLight = Color(0xFF7EE8E1);

  // 보라 계열
  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleLight = Color(0xFFA78BFA);

  // 그라데이션 정의
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [mint, teal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFE0F7FA), Color(0xFFF3E5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradientDark = LinearGradient(
    colors: [Color(0xFF1A3A3A), Color(0xFF2A1A3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [purple, mint],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
