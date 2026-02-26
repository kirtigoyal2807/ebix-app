import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../widgets/app_app_bar.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.privacyPolicy,
        isMoreMenu: false,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lmd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                context.l10n.privacyIntro,
                style: (context) => AppTextStyles.bodyText(
                  context,
                ).copyWith(height: 1.55, color: AppColors.placeHolderText),
                maxLines: 8,
              ),
              SizedBox(height: AppSpacing.md),

              AppText(
                "1. ${context.l10n.privacyInfoTitle}",
                style: (context) => AppTextStyles.experienceButton(
                  context,
                ).copyWith(height: 1.6),
              ),

              SizedBox(height: AppSpacing.sm),
              AppText(
                context.l10n.privacyInfoBody,
                style: (context) => AppTextStyles.bodyText(
                  context,
                ).copyWith(height: 1.55, color: AppColors.placeHolderText),
                maxLines: 5,
              ),

              SizedBox(height: AppSpacing.md),

              AppText(
                "2. ${context.l10n.privacyUsageTitle}",

                style: (context) => AppTextStyles.experienceButton(
                  context,
                ).copyWith(height: 1.6),
              ),

              SizedBox(height: AppSpacing.sm),
              AppText(
                context.l10n.privacyUsageBody,
                style: (context) => AppTextStyles.bodyText(
                  context,
                ).copyWith(height: 1.55, color: AppColors.placeHolderText),
                maxLines: 5,
              ),

              SizedBox(height: AppSpacing.md),

              AppText(
                "3. ${context.l10n.privacySharingTitle}",

                style: (context) => AppTextStyles.experienceButton(
                  context,
                ).copyWith(height: 1.6),
              ),

              SizedBox(height: AppSpacing.sm),
              AppText(
                context.l10n.privacySharingBody,
                style: (context) => AppTextStyles.bodyText(
                  context,
                ).copyWith(height: 1.55, color: AppColors.placeHolderText),
                maxLines: 5,
              ),
              SizedBox(height: AppSpacing.md),
              AppText(
                "4. ${context.l10n.privacyRightsTitle}",

                style: (context) => AppTextStyles.experienceButton(
                  context,
                ).copyWith(height: 1.6),
              ),

              SizedBox(height: AppSpacing.sm),
              AppText(
                context.l10n.privacyRightsBody,
                style: (context) => AppTextStyles.bodyText(
                  context,
                ).copyWith(height: 1.55, color: AppColors.placeHolderText),
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
