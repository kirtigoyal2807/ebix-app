import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/features/auth/utils/branch_location_utils.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/inline_validation_banner.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';
import 'widgets/branch_option.dart';

class SignUpBranchView extends StatefulWidget {
  const SignUpBranchView({super.key});

  @override
  State<SignUpBranchView> createState() => _SignUpBranchViewState();
}

class _SignUpBranchViewState extends State<SignUpBranchView> {
  double? _userLat;
  double? _userLng;
  bool _awaitingPermission = true;
  String? _branchPickErrorMessage;
  String? _branchSubmitErrorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _requestLocationAndLoadBranches();
    });
  }

  Future<void> _requestLocationAndLoadBranches() async {
    if (mounted) {
      setState(() {
        _awaitingPermission = true;
        _userLat = null;
        _userLng = null;
      });
    }

    final coords = await BranchLocationUtils.resolveUserCoordinates(context);
    if (!mounted) return;

    setState(() {
      _userLat = coords.lat;
      _userLng = coords.lng;
    });

    await context.read<AuthCubit>().loadSignUpBranches(
      lat: coords.lat,
      lng: coords.lng,
    );
    if (!mounted) return;
    setState(() => _awaitingPermission = false);
  }

  void _onFinish(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    if (cubit.state.selectedSignUpBranchId == null) {
      setState(() {
        _branchPickErrorMessage = context.l10n.pleaseSelectBranch;
      });
      return;
    }
    setState(() {
      _branchPickErrorMessage = null;
      _branchSubmitErrorMessage = null;
    });
    cubit.submitSignUpHomeBranchAndFinish();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.signUpHomeBranchStatus ==
                SignUpHomeBranchStatus.loading &&
            current.signUpHomeBranchStatus == SignUpHomeBranchStatus.idle &&
            current.signUpHomeBranchErrorMessage.isNotEmpty &&
            current.signUpHomeBranchFieldErrors.isEmpty;
      },
      listener: (context, state) {
        final text = state.signUpHomeBranchErrorMessage.trim().isEmpty
            ? context.l10n.loginErrorGeneric
            : state.signUpHomeBranchErrorMessage.trim();
        setState(() => _branchSubmitErrorMessage = text);
      },
      builder: (context, state) {
        final branches = state.signUpBranches;
        final loading =
            _awaitingPermission ||
            state.signUpBranchesLoadStatus == SignUpBranchesLoadStatus.loading;
        final failure =
            state.signUpBranchesLoadStatus == SignUpBranchesLoadStatus.failure;
        final fe = state.signUpHomeBranchFieldErrors;
        final saving =
            state.signUpHomeBranchStatus == SignUpHomeBranchStatus.loading;

        return AppScaffold(
          appBar: AppAppBar(
            onBack: () {
              context.read<AuthCubit>().previousSignUpStep();
            },
            title: context.l10n.selectedBranch,
            isMoreMenu: false,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: AppSpacing.xi),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: const SignUpProgress(currentStep: 4, totalSteps: 5),
                ),
                SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: RichText(
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
                ),
                SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: _requestLocationAndLoadBranches,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: AppSpacing.lg),
                                SignUpHeader(
                                  title: context.l10n.branchTitle,
                                  subtitle: context.l10n.branchSubtitle,
                                  step: 3,
                                  totalSteps: 4,
                                ),
                                SizedBox(height: AppSpacing.lg),
                                if (loading)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppSpacing.xxl,
                                    ),
                                    child: Center(
                                      child: const AppInlineBusy(),
                                    ),
                                  )
                                else if (failure)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AppText(
                                        state.signUpBranchesErrorMessage.isEmpty
                                            ? context.l10n.branchesCouldNotLoad
                                            : state.signUpBranchesErrorMessage,
                                        style: (context) =>
                                            AppTextStyles.body(
                                              context,
                                            ).copyWith(
                                              color: isDark
                                                  ? AppColors.redDark
                                                  : AppColors.redLight,
                                            ),
                                      ),
                                      SizedBox(height: AppSpacing.md),
                                      AppButton(
                                        key: const ValueKey(
                                          'sign_up_branches_retry',
                                        ),
                                        label: context.l10n.retry,
                                        onPressed:
                                            _requestLocationAndLoadBranches,
                                      ),
                                    ],
                                  )
                                else if (branches.isEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppSpacing.xxl,
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: AppSpacing.md),
                                          AppText(
                                            context.l10n.noBranchesAvailable,
                                            style: (context) =>
                                                AppTextStyles.body(
                                                  context,
                                                ).copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).hintColor,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  ..._branchTiles(
                                    context,
                                    BranchLocationUtils.sortNearestFirst(
                                      branches,
                                      userLat: _userLat,
                                      userLng: _userLng,
                                    ),
                                    state.selectedSignUpBranchId,
                                    fe,
                                  ),
                                SizedBox(height: AppSpacing.xxxl * 2),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: AppSpacing.md + 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin:
                                  Alignment.bottomCenter, // start from bottom
                              end: Alignment.topCenter, // fade to top
                              colors: isDark
                                  ? [
                                      AppColors.darkShadow,
                                      AppColors.darkShadow.withValues(alpha: 0),
                                    ]
                                  : [
                                      Colors.white,
                                      Colors.white.withValues(alpha: 0),
                                    ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: AppSpacing.md,
                        child: Column(
                          children: [
                            if (_branchPickErrorMessage != null)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                ),
                                child: InlineValidationBanner(
                                  message: _branchPickErrorMessage!,
                                ),
                              ),
                            if (_branchSubmitErrorMessage != null &&
                                (_branchPickErrorMessage == null))
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                ),
                                child: InlineValidationBanner(
                                  message: _branchSubmitErrorMessage!,
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              child: AppButton(
                                key: const ValueKey('sign_up_branch_finish'),
                                label: context.l10n.finishSignUp,
                                isLoading: saving,
                                onPressed:
                                    (loading ||
                                        saving ||
                                        failure ||
                                        branches.isEmpty ||
                                        state.selectedSignUpBranchId == null)
                                    ? null
                                    : () => _onFinish(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // if (_branchPickErrorMessage != null)
                //   Padding(
                //     padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                //     child: InlineValidationBanner(
                //       message: _branchPickErrorMessage!,
                //     ),
                //   ),
                // if (_branchSubmitErrorMessage != null &&
                //     (_branchPickErrorMessage == null))
                //   Padding(
                //     padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                //     child: InlineValidationBanner(
                //       message: _branchSubmitErrorMessage!,
                //     ),
                //   ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                //   child: AppButton(
                //     key: const ValueKey('sign_up_branch_finish'),
                //     label: context.l10n.finishSignUp,
                //     isLoading: saving,
                //     onPressed:
                //         (loading || saving || failure || branches.isEmpty)
                //         ? null
                //         : () => _onFinish(context),
                //   ),
                // ),
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
      final distance = BranchLocationUtils.distanceLabel(
        b,
        userLat: _userLat,
        userLng: _userLng,
      );

      out.add(
        KeyedSubtree(
          key: ValueKey('sign_up_branch_${b.id}'),
          child: BranchOption(
            title: b.title,
            city: b.city,
            distance: distance,
            type: b.typeLabel,
            selected: selected,
            onTap: () {
              cubit.selectSignUpBranch(b.id);
              setState(() => _branchPickErrorMessage = null);
            },
            imageUrl: b.imageUrl,
          ),
        ),
      );
      if (i < branches.length - 1) {
        out.add(SizedBox(height: AppSpacing.md));
      }
    }
    final homeErr = fe['homebranchid'] ?? fe['home_branch_id'];
    if (homeErr != null) {
      out.add(SizedBox(height: AppSpacing.sm));
      out.add(
        Center(
          child: AppText(
            homeErr,
            style: (c) => AppTextStyles.caption(
              c,
            ).copyWith(color: isDark ? AppColors.redDark : AppColors.redLight),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return out;
  }
}
