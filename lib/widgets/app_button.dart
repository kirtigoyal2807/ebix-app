import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart' show AppRadius;
import 'package:pilates_app/config/theme/app_spacing.dart' show AppSpacing;
import 'package:pilates_app/config/theme/app_text_styles.dart'
    show AppTextStyles;

enum AppButtonVariant { primary, secondary, disable }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool expanded;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expanded = true,
    this.variant = AppButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == AppButtonVariant.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final button = isPrimary
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
              // isDark
              //     ? AppColors.primaryDarkButton
              //     :
              AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              padding: EdgeInsets.symmetric(
                vertical: (AppSpacing.buttonHeight - 30) / 2,
              ),
              minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
            ),
            child: Text(label, style: AppTextStyles.button(context)),
          )
        : variant == AppButtonVariant.disable
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.lightBlackColor
                  : AppColors.darkGreyBorder,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              padding: EdgeInsets.symmetric(
                vertical: (AppSpacing.buttonHeight - 30) / 2,
              ),
              minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
            ),
            child: Text(
              label,
              style: AppTextStyles.button(context).copyWith(
                color: isDark
                    ? AppColors.lightDarkGrey
                    : AppColors.languageTextDark,
              ),
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark
                  ? AppColors.primaryDark
                  : AppColors.primaryBrown,
              side: BorderSide(
                color: (isDark ? AppColors.greyText : AppColors.buttonBorder),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              padding: EdgeInsets.symmetric(
                vertical: (AppSpacing.buttonHeight - 30) / 2,
              ),
              minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
            ),
            child: Text(
              label,
              style: AppTextStyles.button(context).copyWith(
                color: isDark ? AppColors.lightText : AppColors.darkText,
              ),
            ),
          );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
