import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';

/// Shared outline field chrome for [AppTextField], [AppDropDown], etc.
class AppFormFieldDecoration {
  AppFormFieldDecoration._();

  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 14,
  );

  /// Same outer height as a single-line [TextFormField] with [contentPadding].
  static const double singleLineFieldHeight = 56;

  static OutlineInputBorder _outlineBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static InputDecoration outline({
    required BuildContext context,
    bool hasError = false,
    String? hintText,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final errorAccent = isDark ? AppColors.redDark : AppColors.redLight;
    final borderColor = hasError ? errorAccent : theme.dividerColor;
    final focusedBorderColor =
        hasError ? errorAccent : theme.colorScheme.primary;

    return InputDecoration(
      filled: true,
      fillColor: theme.scaffoldBackgroundColor,
      hintText: hintText,
      isDense: false,
      contentPadding: contentPadding,
      enabledBorder: _outlineBorder(borderColor),
      border: _outlineBorder(borderColor),
      disabledBorder: _outlineBorder(borderColor),
      focusedBorder: _outlineBorder(focusedBorderColor, width: 1.5),
      errorBorder: _outlineBorder(errorAccent),
      focusedErrorBorder: _outlineBorder(errorAccent, width: 1.5),
    );
  }
}
