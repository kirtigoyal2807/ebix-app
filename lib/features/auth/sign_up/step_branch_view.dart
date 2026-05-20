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
import 'package:pilates_app/widgets/inline_validation_banner.dart';

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
                                      child: CircularProgressIndicator(),
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
                                    _branchesNearestFirst(branches),
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

  double? _distanceMetersToBranch(Branch branch) {
    if (_userLat == null ||
        _userLng == null ||
        branch.lat == null ||
        branch.lng == null) {
      return null;
    }
    return Geolocator.distanceBetween(
      _userLat!,
      _userLng!,
      branch.lat!,
      branch.lng!,
    );
  }

  /// When location is available, nearest branch first (lowest distance).
  List<Branch> _branchesNearestFirst(List<Branch> branches) {
    if (_userLat == null || _userLng == null) {
      return branches;
    }
    final sorted = List<Branch>.from(branches);
    sorted.sort((a, b) {
      final da = _distanceMetersToBranch(a);
      final db = _distanceMetersToBranch(b);
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return da.compareTo(db);
    });
    return sorted;
  }

  String _distanceLabelForBranch(Branch branch) {
    final meters = _distanceMetersToBranch(branch);
    if (meters == null) {
      return branch.distance.isEmpty ? '-' : branch.distance;
    }
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
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
      final distance = _distanceLabelForBranch(b);

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
