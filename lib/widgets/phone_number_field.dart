import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import 'app_text.dart';

class PhoneNumberField extends StatefulWidget {
  final String label;
  final String countryCode;
  final String flagAsset;
  final TextEditingController? controller;
  final String? errorText;
  final Function(CountryCode)? onCountryChanged;
  final ValueChanged<String>? onChanged;

  const PhoneNumberField({
    super.key,
    required this.label,
    required this.countryCode,
    required this.flagAsset,
    this.controller,
    this.errorText,
    this.onCountryChanged,
    this.onChanged,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LABEL
        AppText(
          widget.label,
          style: AppTextStyles.textFieldHeading,
        ),

        const SizedBox(height: AppSpacing.sm),

        /// FIELD
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: hasError
                  ? (isDark ? AppColors.redDark : AppColors.redLight)
                  : (_isFocused ? theme.colorScheme.primary : theme.dividerColor),
              width: _isFocused ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              CountryCodePicker(
                headerText: context.l10n.selectCountry,
                onChanged: (CountryCode countryCode) {
                  widget.onCountryChanged?.call(countryCode);
                },
                initialSelection:"+966",
                // widget.countryCode.replaceFirst('+', ''),
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                searchDecoration: InputDecoration(
                  hintText: context.l10n.searchCountry,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                ),
                textStyle: theme.textTheme.bodyMedium,
                flagWidth: 24,
              ),

              /// DIVIDER
              Container(
                width: 1,
                height: 24,
                color: theme.dividerColor,
              ),

              /// PHONE INPUT
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  onChanged: widget.onChanged,
                  style: AppTextStyles.textField(context),
                  decoration: InputDecoration(
                    hintText: 'XXXXXXXXXX',
                    hintStyle: AppTextStyles.textField(context).copyWith(color: AppColors.lightGrey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// ERROR MESSAGE
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
                  widget.errorText!,
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
