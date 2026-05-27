import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_spacing.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';

Future<bool?> showLogoutConfirmationBottomSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: AppColors.blackColor.withValues(alpha: 0.45),
    backgroundColor:
        isDark ? AppColors.homeBackground : AppColors.whiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    elevation: 0,
    clipBehavior: Clip.antiAlias,
    builder: (sheetContext) {
      final bottomInset = MediaQuery.paddingOf(sheetContext).bottom;
      return Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
          bottomInset + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              sheetContext.l10n.logoutSheetMessage,
              style: (c) => AppTextStyles.boldBody(c).copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(c).brightness == Brightness.dark
                    ? AppColors.textPrimaryDark
                    : AppColors.darkText,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.visible,
            ),
            SizedBox(height: AppSpacing.xl),
            AppButton(
              label: sheetContext.l10n.cancel,
              variant: AppButtonVariant.primary,
              onPressed: () => Navigator.of(sheetContext).pop(false),
            ),
            SizedBox(height: AppSpacing.md),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(sheetContext).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(sheetContext).brightness == Brightness.dark
                          ? AppColors.darkGreyText
                          : AppColors.textSecondaryLight,
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  sheetContext.l10n.logoutConfirmYesAction,
                  style: AppTextStyles.bodyTextSmall(
                    sheetContext,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
