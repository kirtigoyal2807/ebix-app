import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final bool enabled;

  /// When set, the phone text field only accepts this many digits (e.g. `10`).
  final int? maxPhoneDigits;

  /// ISO 3166-1 alpha-2 for [CountryCodePicker.initialSelection] (e.g. `SA`).
  final String initialCountryIso;

  /// When null, an internal node is created and disposed by this widget.
  final FocusNode? focusNode;

  final TextInputAction textInputAction;

  final ValueChanged<String>? onFieldSubmitted;

  const PhoneNumberField({
    super.key,
    required this.label,
    required this.countryCode,
    required this.flagAsset,
    this.controller,
    this.errorText,
    this.onCountryChanged,
    this.onChanged,
    this.maxPhoneDigits,
    this.initialCountryIso = 'SA',
    this.enabled = true,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
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
        AppText(widget.label, style: AppTextStyles.textFieldHeading),

        SizedBox(height: AppSpacing.sm),

        /// FIELD — phone UX must stay left-to-right in RTL locales.
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: hasError
                    ? (isDark ? AppColors.redDark : AppColors.redLight)
                    : (_isFocused
                          ? theme.colorScheme.primary
                          : theme.dividerColor),
                width: _isFocused ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                CountryCodePicker(
                  headerText: context.l10n.selectCountry,
                  onChanged: widget.enabled
                      ? (CountryCode countryCode) {
                          widget.onCountryChanged?.call(countryCode);
                        }
                      : null,
                  initialSelection: widget.initialCountryIso,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  searchDecoration: InputDecoration(
                    hintText: context.l10n.searchCountry,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  textStyle: theme.textTheme.bodyMedium,
                  flagWidth: 24,
                ),

                /// DIVIDER
                Container(width: 1, height: 24, color: theme.dividerColor),

                /// PHONE INPUT
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    textInputAction: widget.textInputAction,
                    onSubmitted: widget.onFieldSubmitted,
                    inputFormatters: widget.maxPhoneDigits != null
                        ? <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(
                              widget.maxPhoneDigits,
                            ),
                          ]
                        : null,
                    onChanged: widget.onChanged,
                    style: AppTextStyles.textField(context),
                    decoration: InputDecoration(
                      hintText: 'XXXXXXXXXX',
                      hintStyle: AppTextStyles.textField(
                        context,
                      ).copyWith(color: AppColors.lightGrey),
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
