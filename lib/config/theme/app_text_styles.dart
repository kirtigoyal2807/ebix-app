import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static bool _isAr(BuildContext context) {
    try {
      return Localizations.localeOf(context).languageCode == 'ar';
    } catch (e) {
      return false;
    }
  }

  static TextStyle _applyArStyle(
    BuildContext context,
    TextStyle style, {
    required bool isHeading,
    bool hasExplicitWeight = false,
  }) {
    if (_isAr(context)) {
      return style.copyWith(
        fontFamily: 'CoHeadline',
        fontWeight: hasExplicitWeight
            ? style.fontWeight
            : (isHeading ? FontWeight.bold : FontWeight.normal),
      );
    }
    return style;
  }

  static TextStyle headline(BuildContext context) {
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      isHeading: true,
    );
  }

  static TextStyle bottomSheet(BuildContext context) {
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      isHeading: true,
    );
  }

  static TextStyle heading1(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.gelasio(
        fontSize: 25,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        height: 1.1,
      ),
      isHeading: true,
    );
  }

  static TextStyle body(BuildContext context, {FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: isDark ? AppColors.languageTextDark : AppColors.languageIcon,
      ),
      isHeading: false,
      hasExplicitWeight: fontWeight != null,
    );
  }

  static TextStyle boldBody(BuildContext context, {FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: isDark ? AppColors.languageTextDark : AppColors.languageIcon,
      ),
      isHeading: true,
      hasExplicitWeight: fontWeight != null,
    );
  }

  static TextStyle bodyText(BuildContext context, {FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: isDark ? AppColors.darkGreyText : AppColors.greyText,
        height: 1.4,
      ),
      isHeading: false,
      hasExplicitWeight: fontWeight != null,
    );
  }

  static TextStyle bodyTextSmall(
    BuildContext context, {
    FontWeight? fontWeight,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: isDark ? AppColors.darkGreyText : AppColors.greyText,
        height: 1,
      ),
      isHeading: false,
      hasExplicitWeight: fontWeight != null,
    );
  }

  static TextStyle bodyLightText(BuildContext context) {
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.lightGrey,
        height: 1,
      ),
      isHeading: false,
    );
  }

  static TextStyle caption(BuildContext context, {FontWeight? fontWeight}) {
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: AppColors.lightGrey,
      ),
      isHeading: false,
      hasExplicitWeight: fontWeight != null,
    );
  }

  static TextStyle captionText(BuildContext context, {FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: isDark ? AppColors.lightDarkGrey : AppColors.lightGreyText,
      ),
      isHeading: false,
      hasExplicitWeight: fontWeight != null,
    );
  }

  static TextStyle button(BuildContext context) {
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      isHeading: true,
    );
  }

  static TextStyle textFieldHeading(
    BuildContext context, {
    FontWeight? fontWeight,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        height: 1.55,
      ),
      isHeading: true,
      hasExplicitWeight: fontWeight != null,
    );
  }

  static TextStyle textField(BuildContext context, {FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        height: 1.6,
      ),
      isHeading: false,
      hasExplicitWeight: fontWeight != null,
    );
  }

  static TextStyle phoneCountryCodeDial(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        // fontSize: 15,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        height: 1.2,
        decoration: TextDecoration.none,
      ),
      isHeading: false,
    );
  }

  static TextStyle phoneCountryCodeBottomSheetItem(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        height: 1.25,
        decoration: TextDecoration.none,
      ),
      isHeading: false,
    );
  }

  static TextStyle appBarTitle(BuildContext context, {FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        height: 1.4,
      ),
      isHeading: true,
      hasExplicitWeight: fontWeight != null,
    );
  }

  static TextStyle headingSmall(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.lightText : AppColors.darkText,
      ),
      isHeading: true,
    );
  }

  // Splash Screen Styles

  static TextStyle splashLogoTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.splashTextDark : AppColors.splashTextLight,
        letterSpacing: 0,
      ),
      isHeading: true,
    );
  }

  static TextStyle splashStudio(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.splashTextDark : AppColors.splashTextLight,
        letterSpacing: 2.0,
      ),
      isHeading: false,
    );
  }

  static TextStyle splashTagline(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.splashTextDark : AppColors.splashTextLight,
        letterSpacing: 0,
      ),
      isHeading: false,
    );
  }

  static TextStyle splashVersion(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.splashTextDark : AppColors.versionColor,
        letterSpacing: 0,
      ),
      isHeading: false,
    );
  }

  static TextStyle bottomSheetTitle(
    BuildContext context, {
    FontWeight? fontWeight,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        letterSpacing: 0.16,
        height: 1.2,
      ),
      isHeading: true,
      hasExplicitWeight: fontWeight != null,
    );
  }

  static TextStyle helpAndSupportItemLabel(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.lightText : AppColors.darkText,
      ),
      isHeading: true,
    );
  }

  static TextStyle helpAndSupportItemSubLabel(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.darkGreyText : AppColors.greyText,
      ),
      isHeading: false,
    );
  }

  static TextStyle experienceButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        height: 1.2,
      ),
      isHeading: true,
    );
  }

  static TextStyle appBarText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.lightText : AppColors.darkText,
      ),
      isHeading: true,
    );
  }

  static TextStyle gelasioMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.gelasio(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        height: 1.1,
      ),
      isHeading: true,
    );
  }

  static TextStyle gelasioRegular(
    BuildContext context, {
    FontWeight? fontWeight,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _applyArStyle(
      context,
      GoogleFonts.gelasio(
        fontSize: 18,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        height: 1.1,
        // letterSpacing: -2,
      ),
      isHeading: false,
      hasExplicitWeight: fontWeight != null,
    );
  }

  /// Bottom navigation labels: Inter Semibold when selected, Inter Medium otherwise.
  static TextStyle bottomNavLabel(
    BuildContext context, {
    required double fontSize,
    required bool selected,
  }) {
    return _applyArStyle(
      context,
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
      isHeading: selected,
      hasExplicitWeight: true,
    );
  }
}
