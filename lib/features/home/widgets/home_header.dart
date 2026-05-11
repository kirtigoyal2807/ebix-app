import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/language_bottom_sheet.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  void _showLanguageSelector(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: AppColors.bottomSheetShadow,
      builder: (_) => const LanguageBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.height < 667;

    return SizedBox(
      width: double.infinity,

      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: const LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [Color(0xFFF3ECE7), Color(0xFFF7EBDD)],
              ),
            ),
            child: Image.asset(
              isDark
                  ? 'assets/images/png/ic_home_top_dark.png'
                  : 'assets/images/png/ic_home_top_light.png',
              // height: 222,
              // size.height * 0.33,
              height: size.width * 0.6,
              width: size.width,
              // * 0.5,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: size.width * 0.16,
              // vertical: isSmallScreen ? AppSpacing.xxl : AppSpacing.xxxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: AppSpacing.sm),
                            child: AppText(
                              context.l10n.hiUser(userName),
                              style: (context) =>
                                  AppTextStyles.heading1(context).copyWith(
                                    fontSize: size.width * 0.065 > 24
                                        ? 24
                                        : size.width * 0.065,
                                    color: isDark
                                        ? AppColors.lightText
                                        : AppColors.languageIcon,
                                  ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          AppText(
                            context.l10n.readyToFlow,
                            style: (context) =>
                                AppTextStyles.body(context).copyWith(
                                  fontSize: size.width * 0.04 > 14
                                      ? 14
                                      : size.width * 0.04,
                                  color: isDark
                                      ? AppColors.lightText
                                      : AppColors.languageIcon,
                                ),
                          ),
                        ],
                      ),
                    ),
                    _buildLanguageSelector(context, isDark),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, bool isDark) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final languageCode = state.locale.languageCode.toUpperCase();

        return InkWell(
          onTap: () => _showLanguageSelector(context),
          borderRadius: BorderRadius.circular(AppRadius.pillRadius),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
              border: Border.all(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(AppRadius.pillRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  size: 18,
                  color: isDark
                      ? AppColors.languageIconDark
                      : AppColors.languageIcon,
                ),
                SizedBox(width: AppSpacing.xs + 2),
                AppText(languageCode, style: AppTextStyles.body),
                SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: isDark ? AppColors.lightGrey : AppColors.arrowIcon,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
