import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/widgets/app_form_field_decoration.dart';

import 'app_text.dart';

bool _dropdownValueInItems<T>(T? value, List<DropdownMenuItem<T>> items) {
  if (value == null) return false;
  for (final item in items) {
    if (item.value == value) return true;
  }
  return false;
}

class AppDropDown<T> extends StatelessWidget {
  const AppDropDown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.errorText,
  });

  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = errorText != null;
    final selectedValue = _dropdownValueInItems(value, items) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, style: AppTextStyles.textFieldHeading),
        SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<T>(
          initialValue: selectedValue,
          isExpanded: true,
          decoration: AppFormFieldDecoration.outline(
            context: context,
            hasError: hasError,
          ),
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
          padding: EdgeInsets.zero,
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
