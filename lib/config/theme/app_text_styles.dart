import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle headline(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle heading1(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.gelasio(
      fontSize: 25,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.lightText : AppColors.darkText,
      height: 1.1,
    );
  }

  static TextStyle body(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.languageTextDark : AppColors.languageIcon,
    );
  }

  static TextStyle bodyText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.darkGreyText : AppColors.greyText,
      height: 1.4,
    );
  }

  static TextStyle bodyTextSmall(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.darkGreyText : AppColors.greyText,
      height: 1,
    );
  }

  static TextStyle caption(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightGrey,
    );
  }

  static TextStyle captionText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.lightDarkGrey : AppColors.lightGreyText,
    );
  }

  static TextStyle button(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static TextStyle textFieldHeading(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.lightText : AppColors.darkText,
      height: 1.55,
    );
  }

  static TextStyle textField(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.lightText : AppColors.darkText,
      height: 1.6,
    );
  }

  static TextStyle appBarTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.lightText : AppColors.darkText,
      height: 1.4,
    );
  }

  static TextStyle headingSmall(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.lightText : AppColors.darkText,
    );
  }

  // Splash Screen Styles

  static TextStyle splashLogoTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.playfairDisplay(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.splashTextDark : AppColors.splashTextLight,
      letterSpacing: 0,
    );
  }

  static TextStyle splashStudio(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.splashTextDark : AppColors.splashTextLight,
      letterSpacing: 2.0,
    );
  }

  static TextStyle splashTagline(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.splashTextDark : AppColors.splashTextLight,
      letterSpacing: 0,
    );
  }

  static TextStyle splashVersion(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.splashTextDark : AppColors.versionColor,
      letterSpacing: 0,
    );
  }

  static TextStyle bottomSheetTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.lightText : AppColors.darkText,
      letterSpacing: 0.16,
      height: 1.2,
    );
  }

  static TextStyle helpAndSupportItemLabel(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.lightText : AppColors.darkText,
    );
  }

  static TextStyle helpAndSupportItemSubLabel(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.darkGreyText : AppColors.greyText,
    );
  }

  static TextStyle experienceButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.lightText : AppColors.darkText,
      height: 1.2,
    );
  }
}
