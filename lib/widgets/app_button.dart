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
  final double? buttonHeight;
  final double? verticalPadding;
  final Color? buttonColor;
  final double? buttonFontSize;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expanded = true,
    this.variant = AppButtonVariant.primary,
    this.verticalPadding,
    this.buttonHeight,
    this.buttonColor,
    this.buttonFontSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == AppButtonVariant.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveOnPressed = isLoading ? null : onPressed;

    final button = isPrimary
        ? ElevatedButton(
            onPressed: effectiveOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  // isDark
                  //     ? AppColors.primaryDarkButton
                  //     :
                  buttonColor ?? AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding ?? (AppSpacing.buttonHeight - 30) / 2,
              ),
              // 🔒 Lock height
              fixedSize: Size(
                double.infinity,
                buttonHeight ?? AppSpacing.buttonHeight,
              ),

              // ✂️ Remove extra touch padding
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: isLoading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark ? AppColors.whiteColor : Colors.white,
                    ),
                  )
                : Text(
                    label,
                    style: AppTextStyles.button(
                      context,
                    ).copyWith(fontSize: buttonFontSize ?? 16),
                  ),
          )
        : variant == AppButtonVariant.disable
        ? ElevatedButton(
            onPressed: effectiveOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.lightBlackColor
                  : AppColors.darkGreyBorder,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding ?? (AppSpacing.buttonHeight - 30) / 2,
              ),
              // 🔒 Lock height
              fixedSize: Size(
                double.infinity,
                buttonHeight ?? AppSpacing.buttonHeight,
              ),

              // ✂️ Remove extra touch padding
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    label,
                    style: AppTextStyles.button(context).copyWith(
                      color: isDark
                          ? AppColors.lightDarkGrey
                          : AppColors.languageTextDark,
                      fontSize: buttonFontSize ?? 16,
                    ),
                  ),
          )
        : OutlinedButton(
            onPressed: effectiveOnPressed,
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
                vertical: verticalPadding ?? (AppSpacing.buttonHeight - 30) / 2,
              ),
              // minimumSize: Size(
              //   double.infinity,
              //   buttonHeight ?? AppSpacing.buttonHeight,
              // ),
              // 🔒 Lock height
              fixedSize: Size(
                double.infinity,
                buttonHeight ?? AppSpacing.buttonHeight,
              ),

              // ✂️ Remove extra touch padding
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: isLoading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark ? AppColors.lightText : AppColors.darkText,
                    ),
                  )
                : Text(
                    label,
                    style: AppTextStyles.button(context).copyWith(
                      color: isDark ? AppColors.lightText : AppColors.darkText,
                      fontSize: buttonFontSize ?? 16,
                    ),
                  ),
          );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
