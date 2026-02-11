import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          // Note: The screenshot shows "Terms & Conditions" as the screen header, so we might want to check the AppBar title.
          // But it typically has a secondary header inside or just relies on the AppBar.
          // The screenshot shows "Terms & Conditions" as a large title inside the page too.
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    l10n.termsAndConditions,
                    style: (style) => AppTextStyles.heading1(context),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    l10n.pleaseReviewTerms,
                    style: (context) => AppTextStyles.bodyText(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Scrollable Terms Container
                  SizedBox(
                    height: size.height * 0.5,
                    // adjust if needed to match design
                    child: Container(
                      width: double.infinity,
                      // padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.homeBackground
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.buttonBorder,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbColor: WidgetStateProperty.all(
                              isDark ? AppColors.languageIconDark : AppColors.languageIcon,
                            ),
                            trackColor: WidgetStateProperty.all(
                              isDark ? AppColors.greyText : AppColors.buttonBorder,
                            ),
                            trackVisibility: WidgetStateProperty.all(true),
                            thickness: WidgetStateProperty.all(4),
                            radius: const Radius.circular(16),
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 4,
                            radius: const Radius.circular(16),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md,horizontal: AppSpacing.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      l10n.subscriptionAgreement,
                                      style: (style) =>
                                          AppTextStyles.helpAndSupportItemLabel(
                                            context,
                                          ).copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                        
                                    const SizedBox(height: AppSpacing.md),
                        
                                    AppText(
                                      l10n.subscriptionTermsText,
                                      style: (style) =>
                                          AppTextStyles.helpAndSupportItemLabel(
                                            context,
                                          ).copyWith(
                                            fontSize: 12,
                                            color: isDark
                                                ? AppColors.darkGreyText
                                                : AppColors.greyText,
                                          ),
                                      maxLines: 100,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (previous, current) =>
                        previous.isTermsAccepted != current.isTermsAccepted,
                    builder: (context, state) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: state.isTermsAccepted,
                              onChanged: (val) {
                                cubit.toggleTermsAccepted(val ?? false);
                              },
                              activeColor: AppColors.primaryBrown,
                              side: BorderSide(
                                color: isDark
                                    ? AppColors.greyText
                                    : AppColors.buttonBorder,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: AppText(
                                l10n.agreeToTermsAndConditions,
                                style: (style) =>
                                    AppTextStyles.helpAndSupportItemLabel(
                                      context,
                                    ).copyWith(fontWeight: FontWeight.w400),
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          // Checkbox

          // Continue Button
          BlocBuilder<SubscriptionCubit, SubscriptionState>(
            buildWhen: (previous, current) =>
                previous.isTermsAccepted != current.isTermsAccepted,
            builder: (context, state) {
              return AppButton(
                label: l10n.continueToPayment,
                onPressed: state.isTermsAccepted
                    ? () {
                        // Navigate to payment or finish flow
                        cubit.nextStep(); // Or handle payment logic
                      }
                    : null, // Disable if not accepted
                buttonColor: AppColors.primaryBrown,
                expanded: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
