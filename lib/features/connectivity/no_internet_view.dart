import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

/// Full-screen offline state. System back closes the app ([SystemNavigator.pop]).
class NoInternetView extends StatelessWidget {
  const NoInternetView({
    super.key,
    required this.onTryAgain,
    this.isChecking = false,
  });

  final VoidCallback onTryAgain;
  final bool isChecking;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.offlineBackgroundDark
        : AppColors.whiteColor;
    final titleColor = isDark ? AppColors.lightText : AppColors.darkText;
    final tryAgainColor = isDark
        ? AppColors.offlineTryAgainDark
        : AppColors.offlineTryAgainLight;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Material(
        color: backgroundColor,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  isDark
                      ? 'assets/images/svg/ic_no_internet_dark.svg'
                      : 'assets/images/svg/ic_no_internet_light.svg',
                  width: 164,
                  height: 164,
                ),
                SizedBox(height: AppSpacing.lmd),
                AppText(
                  context.l10n.offlineTitle,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: (context) => AppTextStyles.gelasioRegular(context)
                      .copyWith(fontSize: 20, color: titleColor),
                ),
                SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: isChecking ? null : onTryAgain,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: AppSpacing.md,
                    ),
                    child: AppText(
                      context.l10n.offlineTryAgain,
                      textAlign: TextAlign.center,
                      style: (context) => AppTextStyles.bodyText(
                        context,
                        fontWeight: FontWeight.w600,
                      ).copyWith(fontSize: 14, color: tryAgainColor),
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
