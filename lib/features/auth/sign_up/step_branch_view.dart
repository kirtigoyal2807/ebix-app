import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
  double? _userLat;
  double? _userLng;
  bool _awaitingPermission = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _requestLocationAndLoadBranches();
    });
  }

  Future<void> _requestLocationAndLoadBranches() async {
    // Every time this screen is opened/refreshed, restart the location flow
    // so branch distance and sorting always use the latest permission decision.
    if (mounted) {
      setState(() {
        _awaitingPermission = true;
        _userLat = null;
        _userLng = null;
      });
    }

    // Use Geolocator for iOS/Android permission prompts. `permission_handler`
    // relies on CocoaPods preprocessor flags; if misconfigured, iOS may never
    // show the system dialog. Geolocator talks to CLLocationManager directly.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (!mounted) return;

    double? lat;
    double? lng;

    // User chose "Don't allow" permanently, or iOS equivalent — open Settings.
    if (permission == LocationPermission.deniedForever) {
      await _showLocationSettingsDialog();
      if (!mounted) return;
      await context.read<AuthCubit>().loadSignUpBranches();
      if (!mounted) return;
      setState(() => _awaitingPermission = false);
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 10),
          ),
        );
        if (!mounted) return;
        lat = position.latitude;
        lng = position.longitude;
        setState(() {
          _userLat = lat;
          _userLng = lng;
        });
      } catch (_) {
        // Couldn't get position (timeout, hardware error, etc.) — fall through
        // and load branches without coordinates.
        if (!mounted) return;
      }
    }

    await context.read<AuthCubit>().loadSignUpBranches(lat: lat, lng: lng);
    if (!mounted) return;
    setState(() => _awaitingPermission = false);
  }

  Future<void> _showLocationSettingsDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.locationPermissionTitle),
        content: Text(context.l10n.locationPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.notNow),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Geolocator.openAppSettings();
            },
            child: Text(context.l10n.openSettings),
          ),
        ],
      ),
    );
  }

  void _onFinish(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    if (cubit.state.selectedSignUpBranchId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.pleaseSelectBranch)));
      return;
    }
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
            : state.signUpHomeBranchErrorMessage;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text)));
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
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
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _requestLocationAndLoadBranches,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.lg),
                          SignUpHeader(
                            title: context.l10n.branchTitle,
                            subtitle: context.l10n.branchSubtitle,
                            step: 3,
                            totalSteps: 4,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (loading)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.xxl,
                              ),
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
                                  onPressed: _requestLocationAndLoadBranches,
                                ),
                              ],
                            )
                          else if (branches.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.xxl,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: AppSpacing.md),
                                    AppText(
                                      context.l10n.noBranchesAvailable,
                                      style: (context) =>
                                          AppTextStyles.body(context).copyWith(
                                            color: Theme.of(context).hintColor,
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

      // Compute distance from user's location to branch coordinates.
      // Priority: calculate locally if we have both positions; otherwise fall
      // back to the server-provided label; otherwise show '-'.
      final String distance;
      if (_userLat != null &&
          _userLng != null &&
          b.lat != null &&
          b.lng != null) {
        final meters = Geolocator.distanceBetween(
          _userLat!,
          _userLng!,
          b.lat!,
          b.lng!,
        );
        if (meters < 1000) {
          distance = '${meters.toStringAsFixed(0)} m';
        } else {
          final km = meters / 1000;
          distance = '${km.toStringAsFixed(1)} km';
        }
      } else {
        distance = b.distance.isEmpty ? '-' : b.distance;
      }

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
            imageUrl: b.imageUrl,
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
