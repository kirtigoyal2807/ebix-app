import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/language_bottom_sheet.dart';
import 'package:pilates_app/features/auth/widgets/help_support_bottom_sheet.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  void _onGetStarted(BuildContext context) {
    context.read<AuthCubit>().goToSignUp();
  }

  void _onAlreadyHaveAccount(BuildContext context) {
    context.read<AuthCubit>().goToSignIn();
  }

  void _showLanguageSelector(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor:
          // isDark
          //     ?
          AppColors.bottomSheetShadow,
      // : Colors.black.withValues(alpha: 0.2),
      // backgroundColor: Colors.transparent,
      builder: (_) => const LanguageBottomSheet(),
    );
  }

  void _showHelp(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: AppColors.bottomSheetShadow,
      // backgroundColor: Colors.transparent, // keep transparent here
      // backgroundColor: Colors.transparent,
      builder: (_) => const HelpSupportBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top header with language selector and help button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalPadding,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Language selector (left in LTR, right in RTL)
                  if (!isRTL)
                    _buildLanguageSelector(context, isDark)
                  else
                    _buildHelpButton(context, isDark),

                  // Help button (right in LTR, left in RTL)
                  if (!isRTL)
                    _buildHelpButton(context, isDark)
                  else
                    _buildLanguageSelector(context, isDark),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenHeight = MediaQuery.sizeOf(context).height;
                  final isSmallScreen = screenHeight < 667; // iPhone SE height

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.horizontalPadding,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: isSmallScreen
                                ? AppSpacing.md
                                : AppSpacing.xl,
                          ),

                          // Pilates mat illustration
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.base,
                            ),
                            child: SvgPicture.asset(
                              // isDark
                              //     ? 'assets/images/svg/ic_onboarding_dark.svg'
                              //     :
                              'assets/images/svg/ic_new_on_boarding.svg',
                              height: screenHeight * 0.32,
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(
                            height: isSmallScreen
                                ? AppSpacing.lg
                                : AppSpacing.xxl,
                          ),

                          // Main title
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                            ),
                            child: AppText(
                              context.l10n.onboarding_title_2,
                              style: AppTextStyles.heading1,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: AppSpacing.base),

                          // Description
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen
                                  ? AppSpacing.md
                                  : AppSpacing.xxl,
                            ),
                            child: AppText(
                              context.l10n.onboarding_desc_2,
                              style: AppTextStyles.bodyText,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                          ),

                          const SizedBox(height: AppSpacing.base),

                          // "No experience needed" with checkmark
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                isDark
                                    ? 'assets/images/svg/ic_check_circle_dark.svg'
                                    : 'assets/images/svg/ic_check_circle_light.svg',
                                height: 13,
                                fit: BoxFit.contain,
                              ),

                              const SizedBox(width: AppSpacing.xs + 2),
                              Flexible(
                                child: AppText(
                                  context.l10n.noExperienceNeeded,
                                  style: (context) => AppTextStyles.captionText(
                                    context,
                                  ).copyWith(color: AppColors.lightGrey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: isSmallScreen
                                ? AppSpacing.md
                                : AppSpacing.xl + AppSpacing.lg,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalPadding,
              ),
              child: Column(
                children: [
                  AppButton(
                    label: context.l10n.getStarted,
                    onPressed: () => _onGetStarted(context),
                    variant: AppButtonVariant.primary,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  AppButton(
                    label: context.l10n.alreadyHaveAccount,
                    onPressed: () => _onAlreadyHaveAccount(context),
                    variant: AppButtonVariant.secondary,
                  ),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              // color: Colors.white,
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
                const SizedBox(width: AppSpacing.xs + 2),
                AppText(languageCode, style: AppTextStyles.body),
                const SizedBox(width: AppSpacing.xs),
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

  Widget _buildHelpButton(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () => _showHelp(context),
      borderRadius: BorderRadius.circular(AppRadius.pillRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          // color: Colors.white,
          border: Border.all(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.pillRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(context.l10n.help, style: AppTextStyles.body),
            const SizedBox(width: AppSpacing.xs),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                // color: AppColors.lightGreyBorder,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.help_outline,
                size: 16,
                color: isDark ? AppColors.lightGrey : AppColors.arrowIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
