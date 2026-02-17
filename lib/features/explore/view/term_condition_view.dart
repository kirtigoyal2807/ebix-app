import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../widgets/app_app_bar.dart';

class TermConditionView extends StatelessWidget {
  const TermConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.termsConditions,
        isMoreMenu: false,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lmd,
        ),
        child: Column(
          children: [
            AppText(
        context.l10n.termsIntro,
              style: (context) => AppTextStyles.bodyText(
                context,
              ).copyWith(height: 1.55, color:isDark ? AppColors.placeHolderText: AppColors.placeHolderText),
              maxLines: 8,
            ),
            SizedBox(height: AppSpacing.lg),
            AppText(
                context.l10n.termsMedicalDisclaimer,
              style: (context) => AppTextStyles.bodyText(
                context,
              ).copyWith(height: 1.55, color:isDark ? AppColors.placeHolderText:  AppColors.placeHolderText),
              maxLines: 5,
            ),
            SizedBox(height: AppSpacing.lg),
            AppText(
                context.l10n.termsAccountResponsibility,
              style: (context) => AppTextStyles.bodyText(
                context,
              ).copyWith(height: 1.55, color:isDark ? AppColors.placeHolderText:  AppColors.placeHolderText),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
