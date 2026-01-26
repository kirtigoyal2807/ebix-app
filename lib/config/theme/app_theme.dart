import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      primaryColor: AppColors.primary,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        background: AppColors.backgroundLight,
        surface: AppColors.surfaceLight,
        onBackground: AppColors.textPrimaryLight,
        error: AppColors.error,
      ),
      dividerColor: AppColors.borderLight,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primaryDark,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        onBackground: AppColors.textPrimaryDark,
        error: AppColors.error,
      ),
      dividerColor: AppColors.borderDark,
    );
  }
}
