import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        tertiary: AppColors.lightTertiary,
        surface: AppColors.lightSurface,
        background: AppColors.lightBackground,
        error: AppColors.lightError,
        onPrimary: AppColors.lightOnPrimary,
        onSecondary: AppColors.lightOnSecondary,
        onBackground: AppColors.lightOnBackground,
        onSurface: AppColors.lightOnSurface,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge
            .copyWith(color: AppColors.lightOnBackground),
        displayMedium: AppTextStyles.displayMedium
            .copyWith(color: AppColors.lightOnBackground),
        displaySmall: AppTextStyles.displaySmall
            .copyWith(color: AppColors.lightOnBackground),
        headlineLarge: AppTextStyles.headlineLarge
            .copyWith(color: AppColors.lightOnBackground),
        headlineMedium: AppTextStyles.headlineMedium
            .copyWith(color: AppColors.lightOnBackground),
        headlineSmall: AppTextStyles.headlineSmall
            .copyWith(color: AppColors.lightOnBackground),
        titleLarge:
            AppTextStyles.titleLarge.copyWith(color: AppColors.lightOnSurface),
        titleMedium:
            AppTextStyles.titleMedium.copyWith(color: AppColors.lightOnSurface),
        titleSmall:
            AppTextStyles.titleSmall.copyWith(color: AppColors.lightOnSurface),
        bodyLarge: AppTextStyles.bodyLarge
            .copyWith(color: AppColors.lightOnBackground),
        bodyMedium: AppTextStyles.bodyMedium
            .copyWith(color: AppColors.lightOnBackground),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
        labelLarge:
            AppTextStyles.labelLarge.copyWith(color: AppColors.lightPrimary),
        labelMedium:
            AppTextStyles.labelMedium.copyWith(color: AppColors.lightPrimary),
        labelSmall:
            AppTextStyles.labelSmall.copyWith(color: AppColors.lightPrimary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.lightPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightError),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey,
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        tertiary: AppColors.darkTertiary,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: AppColors.darkError,
        onPrimary: AppColors.darkOnPrimary,
        onSecondary: AppColors.darkOnSecondary,
        onBackground: AppColors.darkOnBackground,
        onSurface: AppColors.darkOnSurface,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge
            .copyWith(color: AppColors.darkOnBackground),
        displayMedium: AppTextStyles.displayMedium
            .copyWith(color: AppColors.darkOnBackground),
        displaySmall: AppTextStyles.displaySmall
            .copyWith(color: AppColors.darkOnBackground),
        headlineLarge: AppTextStyles.headlineLarge
            .copyWith(color: AppColors.darkOnBackground),
        headlineMedium: AppTextStyles.headlineMedium
            .copyWith(color: AppColors.darkOnBackground),
        headlineSmall: AppTextStyles.headlineSmall
            .copyWith(color: AppColors.darkOnBackground),
        titleLarge:
            AppTextStyles.titleLarge.copyWith(color: AppColors.darkOnSurface),
        titleMedium:
            AppTextStyles.titleMedium.copyWith(color: AppColors.darkOnSurface),
        titleSmall:
            AppTextStyles.titleSmall.copyWith(color: AppColors.darkOnSurface),
        bodyLarge: AppTextStyles.bodyLarge
            .copyWith(color: AppColors.darkOnBackground),
        bodyMedium: AppTextStyles.bodyMedium
            .copyWith(color: AppColors.darkOnBackground),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
        labelLarge:
            AppTextStyles.labelLarge.copyWith(color: AppColors.darkPrimary),
        labelMedium:
            AppTextStyles.labelMedium.copyWith(color: AppColors.darkPrimary),
        labelSmall:
            AppTextStyles.labelSmall.copyWith(color: AppColors.darkPrimary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.darkOnSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: AppColors.darkOnPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.darkPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkError),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey,
        ),
      ),
    );
  }
}
