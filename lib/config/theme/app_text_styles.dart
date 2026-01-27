import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle headline(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle bottomSheet(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle heading1(BuildContext context) =>
      GoogleFonts.gelasio(
        fontSize: 30,
        fontWeight: FontWeight.w500,
        color: AppColors.darkText,
        height: 1.1,
      );

  static TextStyle body(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle bodyText(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.greyText,
        height: 1.5,
      );

  static TextStyle bodyTextSmall(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.greyText,
        height: 1,
      );


  static TextStyle caption(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.lightGrey,
      );

  static TextStyle captionText(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.lightGreyText,
      );

  static TextStyle button(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle textFieldHeading(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.darkText,
      );

  static TextStyle appBarTitle(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.darkText,
      );

  static TextStyle headingSmall(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.darkText,
      );

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
}
