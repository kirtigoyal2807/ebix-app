import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';

import 'package:pilates_app/features/account/widget/app_preference.dart';
import 'package:pilates_app/features/account/widget/billing_and_subscription.dart';
import 'package:pilates_app/features/account/widget/personal_info.dart';
import 'package:pilates_app/features/account/widget/profile_card.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';

import '../../config/theme/app_radius.dart';
import '../../core/localization/localization_extension.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  Future<void> _confirmAndLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.logout),
        content: Text(context.l10n.logoutConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await context.read<AuthCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.accountProfileRefreshStatus !=
              current.accountProfileRefreshStatus ||
          previous.user != current.user,
      builder: (context, authState) {
        final loading =
            authState.accountProfileRefreshStatus ==
            AccountProfileRefreshStatus.loading;
        return Scaffold(
          appBar: AppAppBar(
            title: context.l10n.accountTitle,
            isMoreMenu: false,
          ),
          body: Stack(
            children: [
              AbsorbPointer(
                absorbing: loading,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileCard(),
                        SizedBox(height: AppSpacing.lg),

                        PersonalInfo(),
                        SizedBox(height: AppSpacing.xl),
                        BillingAndSubscription(),
                        SizedBox(height: AppSpacing.xl),
                        AppPreference(),
                        SizedBox(height: AppSpacing.xl),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () => _confirmAndLogout(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.logOutButton,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.xl,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: (AppSpacing.buttonHeight - 30) / 2,
                              ),
                              // 🔒 Lock height
                              fixedSize: Size(
                                double.infinity,
                                AppSpacing.buttonHeight,
                              ),

                              // ✂️ Remove extra touch padding
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Icon(Icons.exit_to_app, color: Colors.white),
                                Text(
                                  context.l10n.logout,
                                  style: AppTextStyles.button(
                                    context,
                                  ).copyWith(fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.base),
                      ],
                    ),
                  ),
                ),
              ),
              if (loading)
                const Positioned.fill(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}
