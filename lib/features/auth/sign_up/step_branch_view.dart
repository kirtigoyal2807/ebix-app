import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';

import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';
import 'widgets/branch_option.dart';

class SignUpBranchView extends StatefulWidget {
  const SignUpBranchView({super.key});

  @override
  State<SignUpBranchView> createState() => _SignUpBranchViewState();
}

class _SignUpBranchViewState extends State<SignUpBranchView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthCubit>().loadSignUpBranches();
    });
  }

  void _onFinish(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    if (cubit.state.selectedSignUpBranchId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.pleaseSelectBranch)),
      );
      return;
    }
    cubit.submitSignUpHomeBranchAndFinish();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.signUpHomeBranchStatus == SignUpHomeBranchStatus.loading &&
            current.signUpHomeBranchStatus == SignUpHomeBranchStatus.idle &&
            current.signUpHomeBranchErrorMessage.isNotEmpty &&
            current.signUpHomeBranchFieldErrors.isEmpty;
      },
      listener: (context, state) {
        final text = state.signUpHomeBranchErrorMessage.trim().isEmpty
            ? context.l10n.loginErrorGeneric
            : state.signUpHomeBranchErrorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text)),
        );
      },
      builder: (context, state) {
        final branches = state.signUpBranches;
        final loading = state.signUpBranchesLoadStatus == SignUpBranchesLoadStatus.loading;
        final failure = state.signUpBranchesLoadStatus == SignUpBranchesLoadStatus.failure;
        final fe = state.signUpHomeBranchFieldErrors;
        final saving = state.signUpHomeBranchStatus == SignUpHomeBranchStatus.loading;

        return AppScaffold(
          appBar: AppAppBar(
            onBack: () {
              context.read<AuthCubit>().previousSignUpStep();
            },
            title: context.l10n.selectedBranch,
            isMoreMenu: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => context.read<AuthCubit>().loadSignUpBranches(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SignUpProgress(currentStep: 4, totalSteps: 5),
                          const SizedBox(height: AppSpacing.sm),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${context.l10n.step} 5',
                                  style: AppTextStyles.caption(context).copyWith(
                                    color: isDark
                                        ? AppColors.languageTextDark
                                        : AppColors.languageIcon,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${context.l10n.offf} 5',
                                  style: AppTextStyles.caption(context),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          SignUpHeader(
                            title: context.l10n.branchTitle,
                            subtitle: context.l10n.branchSubtitle,
                            step: 3,
                            totalSteps: 4,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (loading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (failure)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AppText(
                                  state.signUpBranchesErrorMessage.isEmpty
                                      ? context.l10n.branchesCouldNotLoad
                                      : state.signUpBranchesErrorMessage,
                                  style: (context) =>
                                      AppTextStyles.body(context).copyWith(
                                    color: isDark
                                        ? AppColors.redDark
                                        : AppColors.redLight,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                AppButton(
                                  key: const ValueKey('sign_up_branches_retry'),
                                  label: context.l10n.retry,
                                  onPressed: () =>
                                      context.read<AuthCubit>().loadSignUpBranches(),
                                ),
                              ],
                            )
                          else if (branches.isEmpty)
                            AppText(
                              context.l10n.noBranchesAvailable,
                              style: AppTextStyles.body,
                            )
                          else ..._branchTiles(
                            context,
                            branches,
                            state.selectedSignUpBranchId,
                            fe,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                ),
                AppButton(
                  key: const ValueKey('sign_up_branch_finish'),
                  label: context.l10n.finishSignUp,
                  isLoading: saving,
                  onPressed: (loading || saving || failure || branches.isEmpty)
                      ? null
                      : () => _onFinish(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _branchTiles(
    BuildContext context,
    List<Branch> branches,
    int? selectedId,
    Map<String, String> fe,
  ) {
    final cubit = context.read<AuthCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final out = <Widget>[];
    for (var i = 0; i < branches.length; i++) {
      final b = branches[i];
      final selected = b.id == selectedId;
      final distance = b.distance.isEmpty ? '-' : b.distance;
      out.add(
        KeyedSubtree(
          key: ValueKey('sign_up_branch_${b.id}'),
          child: BranchOption(
            title: b.title,
            city: b.city,
            distance: distance,
            type: b.typeLabel,
            selected: selected,
            onTap: () => cubit.selectSignUpBranch(b.id),
          ),
        ),
      );
      if (i < branches.length - 1) {
        out.add(const SizedBox(height: AppSpacing.md));
      }
    }
    final homeErr = fe['homebranchid'] ?? fe['home_branch_id'];
    if (homeErr != null) {
      out.add(const SizedBox(height: AppSpacing.sm));
      out.add(
        Center(
          child: AppText(
            homeErr,
            style: (c) => AppTextStyles.caption(c).copyWith(
                  color: isDark ? AppColors.redDark : AppColors.redLight,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return out;
  }
}

