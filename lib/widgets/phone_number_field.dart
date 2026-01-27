import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import 'app_text.dart';

class PhoneNumberField extends StatelessWidget {
  final String label;
  final String countryCode;
  final String flagAsset;
  final TextEditingController? controller;
  final Function(CountryCode)? onCountryChanged;

  const PhoneNumberField({
    super.key,
    required this.label,
    required this.countryCode,
    required this.flagAsset,
    this.controller,
    this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LABEL
        AppText(
          label,
          style: AppTextStyles.textFieldHeading,
        ),

        const SizedBox(height: AppSpacing.xs),

        /// FIELD
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: theme.dividerColor,
            ),
          ),
          child: Row(
            children: [
              CountryCodePicker(
                headerText: context.l10n.selectCountry,
                onChanged: (CountryCode countryCode) {
                  onCountryChanged?.call(countryCode);
                },
                initialSelection: countryCode.replaceFirst('+', ''),
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
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'XXXXXXXXXX',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
