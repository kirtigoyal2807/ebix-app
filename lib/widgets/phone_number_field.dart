import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';

import 'app_text.dart';

class PhoneNumberField extends StatelessWidget {
  final String label;
  final String countryCode;
  final String flagAsset;
  final TextEditingController? controller;

  const PhoneNumberField({
    super.key,
    required this.label,
    required this.countryCode,
    required this.flagAsset,
    this.controller,
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


        const SizedBox(height: 6),

        /// FIELD
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: theme.dividerColor,
            ),
            // color: theme.colorScheme.surface,
          ),
          child: Row(
            children: [
              /// FLAG + CODE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      flagAsset,
                      width: 22,
                      height: 16,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      countryCode,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
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
