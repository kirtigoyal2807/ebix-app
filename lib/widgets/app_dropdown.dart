import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';

import 'app_text.dart';

class AppDropDown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? errorText;

  const AppDropDown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.errorText,
  });

  static bool _valueInItems<T>(T? value, List<DropdownMenuItem<T>> items) {
    if (value == null) return false;
    for (final item in items) {
      if (item.value == value) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final hasError = errorText != null;
    final selectedValue = _valueInItems(value, items) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, style: AppTextStyles.textFieldHeading),
        SizedBox(height: AppSpacing.sm),
        ButtonTheme(
          alignedDropdown: true,
          child: InputDecorator(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 4,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: hasError
                      ? (isDark ? AppColors.redDark : AppColors.redLight)
                      : theme.dividerColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : theme.colorScheme.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: isDark ? AppColors.redDark : AppColors.redLight,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: isDark ? AppColors.redDark : AppColors.redLight,
                  width: 1.5,
                ),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                isDense: true,
                value: selectedValue,
                hint: Text(
                  hint,
                  style: AppTextStyles.textField(
                    context,
                  ).copyWith(color: AppColors.lightGrey),
                ),
                items: items,
                onChanged: onChanged,
                style: AppTextStyles.textField(context),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark ? AppColors.lightGrey : AppColors.arrowIcon,
                  size: 24,
                ),
                dropdownColor: isDark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: isDark ? AppColors.redDark : AppColors.redLight,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.redDark : AppColors.redLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
