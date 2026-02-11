import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_text.dart';
import 'account_info_tile.dart';

class AppPreference extends StatelessWidget {
  const AppPreference({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          context.l10n.appPreferences,
          style: (context) => AppTextStyles.captionText(context).copyWith(
            fontWeight: FontWeight.w500,
            height: 1.55,
            color: AppColors.lightGrey,
          ),
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/account/ic_dark_language.svg"
              : "assets/images/svg/account/ic_language.svg",
          title: context.l10n.language,
          subtitle: context.l10n.englishShort,

        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/account/ic_dark_home.svg"
              : "assets/images/svg/account/ic_home.svg",
          title: context.l10n.homeBranch,
          subtitle: context.l10n.updatePreferredStudio,
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/account/ic_dark_theme.svg"
              : "assets/images/svg/account/ic_app_theme.svg",
          title: context.l10n.appTheme,
          subtitle: context.l10n.systemMode,
        ),

      ],
    );
  }
}
