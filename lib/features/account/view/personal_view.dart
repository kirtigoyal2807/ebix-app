import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dropdown.dart';
import '../../../widgets/phone_number_field.dart';
import '../cubit/personal_info_cubit.dart';
import '../cubit/personal_info_state.dart';

class PersonalView extends StatelessWidget {
  const PersonalView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => PersonalInfoCubit(),
      child: Scaffold(
        appBar: AppAppBar(
          onBack: () => Navigator.of(context).pop(),
          title: l10n.personalData,
          isMoreMenu: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/demo images/Trainer Avatar.png",
                    height: 90,
                    width: 90,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Center(
                  child: AppText(
                    l10n.changeProfilePicture,
                    style: (context) => AppTextStyles.body(
                      context,
                    ).copyWith(fontWeight: FontWeight.w400, height: 1.55),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                AppTextField(
                  hint: context.l10n.firstName,
                  label: context.l10n.firstName,
                ),
                SizedBox(height: AppSpacing.md),
                AppTextField(
                  hint: context.l10n.lastName,
                  label: context.l10n.lastName,
                ),
                SizedBox(height: AppSpacing.md),
                AppTextField(
                  hint: context.l10n.recipientEmailHint,
                  label: l10n.emailAddress,
                ),
                SizedBox(height: AppSpacing.md),
                PhoneNumberField(
                  label: context.l10n.phoneNumber,
                  countryCode: '+1',
                  flagAsset: 'assets/flags/us.svg',
                ),
                SizedBox(height: AppSpacing.md),


                AppTextField(
                  hint: context.l10n.fullName,
                  label: l10n.emergencyContactName,
                ),
                SizedBox(height: AppSpacing.md),
                AppTextField(
                  hint: "XXXXXXXXXXX",
                  label: l10n.emergencyContactPhoneNumber,
                ),
                SizedBox(height: AppSpacing.md),

                // Relationship Dropdown
                BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                  buildWhen: (p, c) =>
                      p.emergencyContactRelationship !=
                      c.emergencyContactRelationship,
                  builder: (context, state) {
                    return AppDropDown<String>(
                      label: l10n.relationship,
                      hint: l10n.selectRelationship,
                      value: state.emergencyContactRelationship,
                      items: ['Parent', 'Spouse', 'Sibling', 'Friend', 'Other']
                          .map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: AppTextStyles.textField(context),
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (val) {
                        if (val != null)
                          context
                              .read<PersonalInfoCubit>()
                              .updateEmergencyContactRelationship(val);
                      },
                    );
                  },
                ),
                SizedBox(height: AppSpacing.md),
                BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                  buildWhen: (p, c) => p.idType != c.idType,
                  builder: (context, state) {
                    return AppDropDown<String>(
                      label: l10n.idType,
                      hint: l10n.selectIdType,
                      value: state.idType,
                      items: ['National ID', 'Passport', 'Driver License'].map((
                        e,
                      ) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: AppTextStyles.textField(context),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null)
                          context.read<PersonalInfoCubit>().updateIdType(val);
                      },
                    );
                  },
                ),
                SizedBox(height: AppSpacing.md),
                AppTextField(hint: l10n.idNumber, label: l10n.idNumber),
                SizedBox(height: AppSpacing.lg),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.homeBackground : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor.withValues(alpha: 0.06),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: AppButton(
                    label: l10n.editDetails,
                    onPressed: () {},
                    variant: AppButtonVariant.secondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xl,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
