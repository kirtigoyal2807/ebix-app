import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_radius.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';

class RateSheet extends StatelessWidget {
  const RateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.bottomActionPadding,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeBackground : Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.rateYourClass,
                  textAlign: TextAlign.center,
                  style: (context) => AppTextStyles.gelasioMedium(
                    context,
                  ).copyWith(fontSize: 16, height: 1.55),
                ),

                SizedBox(height: AppSpacing.xs),

                AppText(
                  context.l10n.rateYourClassDesc("Gentle Stretch & Release"),
                  textAlign: TextAlign.start,
                  style: (context) =>
                      AppTextStyles.bodyText(context).copyWith(height: 1.55),
                  maxLines: 3,
                ),

                SizedBox(height: AppSpacing.xs),
                RatingBar.builder(
                  initialRating: 3,
                  unratedColor: isDark
                      ? AppColors.lightGrey
                      : AppColors.darkGreyText,
                  minRating: 0,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 26,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: AppColors.goldStarColor),
                  onRatingUpdate: (rating) {},
                ),
                SizedBox(height: AppSpacing.md),

                Divider(
                  height: 1,
                  color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                ),
                SizedBox(height: AppSpacing.md),
                AppText(
                  context.l10n.rateYourTrainer,
                  textAlign: TextAlign.center,
                  style: (context) => AppTextStyles.gelasioMedium(
                    context,
                  ).copyWith(fontSize: 16, height: 1.55),
                ),

                SizedBox(height: AppSpacing.xs),

                AppText(
                  context.l10n.rateYourTrainerDesc("Sarah Mitchell"),
                  textAlign: TextAlign.start,
                  style: (context) =>
                      AppTextStyles.bodyText(context).copyWith(height: 1.55),
                  maxLines: 3,
                ),

                SizedBox(height: AppSpacing.xs),
                RatingBar.builder(
                  initialRating: 3,
                  unratedColor: isDark
                      ? AppColors.lightGrey
                      : AppColors.darkGreyText,
                  minRating: 0,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 26,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: AppColors.goldStarColor),
                  onRatingUpdate: (rating) {},
                ),
                SizedBox(height: AppSpacing.md),

                Divider(
                  height: 1,
                  color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                ),
                SizedBox(height: AppSpacing.md),
                AppText(
                  context.l10n.writeDetailedReview,
                  textAlign: TextAlign.center,
                  style: (context) => AppTextStyles.gelasioMedium(
                    context,
                  ).copyWith(fontSize: 16, height: 1.55),
                ),
                SizedBox(height: AppSpacing.xs),
                TextFormField(
                  maxLines: 4,
                  style: AppTextStyles.textField(context),
                  decoration: InputDecoration(
                    hintText: context.l10n.shareExperienceHint,
                    hintStyle: AppTextStyles.textField(
                      context,
                    ).copyWith(color: AppColors.lightGrey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),

                    /// BORDER
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: context.l10n.submitReview,
                  onPressed: () {},
                  variant: AppButtonVariant.primary,
                ),

                SizedBox(height: AppSpacing.sm),

                // Cancel
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),

                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: (AppSpacing.buttonHeight - 30) / 2,
                      ),
                      child: AppText(
                        context.l10n.skipForNow,
                        style: (context) => AppTextStyles.button(
                          context,
                        ).copyWith(color: AppColors.lightGrey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
