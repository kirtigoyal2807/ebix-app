import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/success_membership_view.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_dropdown.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

class RequiredInformationView extends StatelessWidget {
  const RequiredInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Warning Info Box
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.upgradeDarkBackgroundColor
                          .withValues(alpha: 0.11) : AppColors.upgradeLightBackgroundColor, // Custom colors to match screenshot
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: isDark ? AppColors.upgradeDarkLockBackgroundColor : AppColors.lightRedColor, // Gold/Brown
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: l10n.requiredForLegalComplianceShort + ': ',
                                  style: AppTextStyles.bodyText(context).copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkGreyText : AppColors.greyText,
                                  ),
                                ),
                                TextSpan(
                                  text: l10n.requiredForLegalCompliance,
                                  style: AppTextStyles.bodyText(context).copyWith(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkGreyText : AppColors.greyText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Emergency Contact Header
                  AppText(
                    l10n.emergencyContact,
                    style: (style) => AppTextStyles.heading1(context),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    l10n.emergencyContactSubtitle,
                    style: (context) => AppTextStyles.bodyText(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Contact Name
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (p, c) => p.emergencyContactName != c.emergencyContactName,
                    builder: (context, state) {
                      return AppTextField(
                        label: l10n.contactName,
                        hint: l10n.fullName,
                        initialValue: state.emergencyContactName,
                        onChanged: cubit.updateEmergencyContactName,
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Relationship Dropdown
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (p, c) => p.emergencyContactRelationship != c.emergencyContactRelationship,
                    builder: (context, state) {
                      return AppDropDown<String>(
                        label: l10n.relationship,
                        hint: l10n.selectRelationship,
                        value: state.emergencyContactRelationship,
                        items: ['Parent', 'Spouse', 'Sibling', 'Friend', 'Other'].map((e) {
                          String label = e;
                          switch (e) {
                            case 'Parent':
                              label = l10n.relationshipParent;
                              break;
                            case 'Spouse':
                              label = l10n.relationshipSpouse;
                              break;
                            case 'Sibling':
                              label = l10n.relationshipSibling;
                              break;
                            case 'Friend':
                              label = l10n.relationshipFriend;
                              break;
                            case 'Other':
                              label = l10n.relationshipOther;
                              break;
                          }
                          return DropdownMenuItem(
                            value: e,
                            child: Text(label, style: AppTextStyles.textField(context)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) cubit.updateEmergencyContactRelationship(val);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Phone Number
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      buildWhen: (p, c) => p.emergencyContactPhone != c.emergencyContactPhone,
                      builder: (context, state) {
                        return AppTextField(
                          label: l10n.phoneNumber,
                          hint: 'XXXXXXXXXX',
                          initialValue: state.emergencyContactPhone,
                          onChanged: cubit.updateEmergencyContactPhone,
                          keyboardType: TextInputType.phone,
                        );
                      },
                    ),

                  const SizedBox(height: AppSpacing.xl),

                  // Identity Verification Header
                  AppText(
                    l10n.identityVerification,
                    style: (style) => AppTextStyles.heading1(context),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    l10n.requiredForLegalComplianceShort,
                    style: (context) => AppTextStyles.bodyText(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ID Type Dropdown
                   BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (p, c) => p.idType != c.idType,
                    builder: (context, state) {
                      return AppDropDown<String>(
                        label: l10n.idType,
                        hint: l10n.selectIdType,
                         value: state.idType,
                        items: ['National ID', 'Passport', 'Driver License'].map((e) {
                          String label = e;
                          switch (e) {
                            case 'National ID':
                              label = l10n.idTypeNationalId;
                              break;
                            case 'Passport':
                              label = l10n.idTypePassport;
                              break;
                            case 'Driver License':
                              label = l10n.idTypeDriverLicense;
                              break;
                          }
                          return DropdownMenuItem(
                            value: e,
                             child: Text(label, style: AppTextStyles.textField(context)),
                          );
                        }).toList(),
                         onChanged: (val) {
                          if (val != null) cubit.updateIdType(val);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ID Number
                   BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (p, c) => p.idNumber != c.idNumber,
                     builder: (context, state) {
                      return AppTextField(
                        label: l10n.idNumber,
                        hint: l10n.idNumber,
                         initialValue: state.idNumber,
                        onChanged: cubit.updateIdNumber,
                      );
                    },
                  ),
                   const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),

          // Continue Button
          AppButton(
            label: l10n.continueToPayment,
            onPressed: () {
               cubit.nextStep();
               Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessMembershipView(),));
            },
            buttonColor: AppColors.primaryBrown,
            expanded: true,
          ),
        ],
      ),
    );
  }
}
