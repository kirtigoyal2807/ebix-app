import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LanguageBottomSheet(),
    );
  }

  void _showHelp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // keep transparent here
      // backgroundColor: Colors.transparent,
      builder: (_) => const HelpSupportBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                  if (!isRTL) _buildLanguageSelector(context)
                  else _buildHelpButton(context),
                  
                  // Help button (right in LTR, left in RTL)
                  if (!isRTL) _buildHelpButton(context)
                  else _buildLanguageSelector(context),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Pilates mat illustration
                      SvgPicture.asset(
                        isDark
                            ? 'assets/images/svg/ic_book_dark.svg'
                            : 'assets/images/svg/ic_book_light.svg',
                        height: 270,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Main title
                      AppText(
                        context.l10n.onboarding_title_2,
                        style: AppTextStyles.heading1,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSpacing.md + AppSpacing.sm),

                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: AppText(
                          context.l10n.onboarding_desc_2,
                          style: AppTextStyles.bodyText,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // "No experience needed" with checkmark
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: AppColors.lightGreyText,
                          ),
                          const SizedBox(width: AppSpacing.xs + 2),
                          AppText(
                            context.l10n.noExperienceNeeded,
                            style: AppTextStyles.captionText,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xl + AppSpacing.lg),
                    ],
                  ),
                ),
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

                  const SizedBox(height: AppSpacing.md),

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

  Widget _buildLanguageSelector(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final languageCode = state.locale.languageCode.toUpperCase();
        
        return InkWell(
          onTap: () => _showLanguageSelector(context),
          borderRadius: BorderRadius.circular(AppRadius.pillRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md + AppSpacing.xs,
              vertical: AppSpacing.sm + 2,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.lightGreyBorder,
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
                  color: AppColors.darkText,
                ),
                const SizedBox(width: AppSpacing.xs + 2),
                Text(
                  languageCode,
                  style: AppTextStyles.body(context).copyWith(
                    color: AppColors.darkText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: AppColors.darkText,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHelpButton(BuildContext context) {
    return InkWell(
      onTap: () => _showHelp(context),
      borderRadius: BorderRadius.circular(AppRadius.pillRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md + AppSpacing.xs,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppColors.lightGreyBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.pillRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.help,
              style: AppTextStyles.body(context).copyWith(
                color: AppColors.darkText,
                fontSize: 14,
              ),
            ),
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
                color: AppColors.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
