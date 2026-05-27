import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/language_bottom_sheet.dart';
import '../../../widgets/theme_bottom_sheet.dart';
import '../view/change_home_branch.dart';
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
        BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (previous, current) =>
              previous.locale != current.locale,
          builder: (context, state) {
            return AccountInfoTile(
              onTap: () {
                _showLanguageSelector(context);
              },
              icon: isDark
                  ? "assets/images/svg/account/ic_dark_language.svg"
                  : "assets/images/svg/account/ic_language.svg",
              title: context.l10n.language,
              subtitle: _languageSubtitle(
                context,
                state.locale.languageCode,
              ),
            );
          },
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangeHomeBranch()),
            );
          },
          icon: isDark
              ? "assets/images/svg/account/ic_dark_home.svg"
              : "assets/images/svg/account/ic_home.svg",
          title: context.l10n.homeBranch,
          subtitle: context.l10n.updatePreferredStudio,
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          onTap: () {
            _showThemeSelector(context);
          },
          icon: isDark
              ? "assets/images/svg/account/ic_dark_theme.svg"
              : "assets/images/svg/account/ic_app_theme.svg",
          title: context.l10n.appTheme,
          subtitle: context.l10n.systemMode,
        ),
      ],
    );
  }

  static String _languageSubtitle(BuildContext context, String languageCode) {
    final l10n = context.l10n;
    switch (languageCode) {
      case 'ar':
        return l10n.arabicShort;
      case 'en':
      default:
        return l10n.englishShort;
    }
  }

  void _showLanguageSelector(BuildContext context) {
    showLanguageBottomSheet(context);
  }

  void _showThemeSelector(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: AppColors.bottomSheetShadow,
      // backgroundColor: Colors.transparent,
      builder: (_) => const ThemeBottomSheet(),
    );
  }
}
