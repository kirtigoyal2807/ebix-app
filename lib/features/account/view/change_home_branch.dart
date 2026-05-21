import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/features/auth/utils/branch_location_utils.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

import '../../auth/sign_up/widgets/branch_option.dart';

class ChangeHomeBranch extends StatefulWidget {
  const ChangeHomeBranch({super.key, this.title, this.readOnly = false});

  final String? title;
  final bool readOnly;

  @override
  State<ChangeHomeBranch> createState() => _ChangeHomeBranchState();
}

class _ChangeHomeBranchState extends State<ChangeHomeBranch> {
  bool _awaitingLocation = true;
  bool _isLoadingBranches = false;
  bool _isUpdatingHomeBranch = false;
  String _loadErrorMessage = '';
  List<Branch> _branches = const [];
  int? _selectedBranchId;
  double? _userLat;
  double? _userLng;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initScreen());
  }

  Future<void> _initScreen() async {
    final authCubit = context.read<AuthCubit>();
    await authCubit.loadProfile(force: true);
    if (!mounted) return;
    _selectedBranchId = _initialSelectedBranchId(authCubit);
    await _requestLocationAndLoadBranches();
  }

  Future<void> _requestLocationAndLoadBranches() async {
    if (mounted) {
      setState(() {
        _awaitingLocation = true;
        _isLoadingBranches = true;
        _loadErrorMessage = '';
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

    await _fetchBranches(lat: coords.lat, lng: coords.lng);
    if (!mounted) return;
    setState(() => _awaitingLocation = false);
  }

  int? _initialSelectedBranchId(AuthCubit authCubit) {
    return authCubit.storedHomeBranchId ??
        _homeBranchIdFromUser(authCubit.state.user);
  }

  static int? _homeBranchIdFromUser(AuthUser? user) {
    final id = user?.homeBranch?.id;
    if (id == null || id <= 0) return null;
    return id;
  }

  Future<void> _fetchBranches({double? lat, double? lng}) async {
    if (mounted) {
      setState(() {
        _isLoadingBranches = true;
        _loadErrorMessage = '';
      });
    }

    final authCubit = context.read<AuthCubit>();
    final queryParameters = <String, dynamic>{
      'page': 1,
      'per_page': 50,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };

    final result = await authCubit.authRepository.listBranches(
      queryParameters: queryParameters,
    );

    if (!mounted) return;

    switch (result) {
      case ApiSuccess(:final data):
        final branches = data.branches
            .where((b) => b.isActive && b.title.trim().isNotEmpty)
            .toList();
        final sorted = BranchLocationUtils.sortNearestFirst(
          branches,
          userLat: _userLat,
          userLng: _userLng,
        );
        setState(() {
          _branches = sorted;
          _isLoadingBranches = false;
          _selectedBranchId = _resolveSelectedBranchId(
            sorted,
            preferredId: _selectedBranchId,
            storedId: authCubit.storedHomeBranchId,
            user: authCubit.state.user,
          );
        });
      case ApiFailure(:final exception):
        setState(() {
          _isLoadingBranches = false;
          _loadErrorMessage = (exception.message ?? '').trim().isNotEmpty
              ? exception.message!.trim()
              : context.l10n.branchesCouldNotLoad;
        });
    }
  }

  /// Keeps the saved home branch selected; only falls back when the user has none.
  static int? _resolveSelectedBranchId(
    List<Branch> branches, {
    required int? preferredId,
    required int? storedId,
    required AuthUser? user,
  }) {
    if (branches.isEmpty) return null;

    for (final candidate in [preferredId, storedId, user?.homeBranch?.id]) {
      if (candidate != null &&
          candidate > 0 &&
          branches.any((b) => b.id == candidate)) {
        return candidate;
      }
    }

    final home = user?.homeBranch;
    final name = home?.name?.trim().toLowerCase();
    if (name != null && name.isNotEmpty) {
      for (final branch in branches) {
        if (branch.title.trim().toLowerCase() == name) {
          return branch.id;
        }
      }
    }

    if (preferredId == null && storedId == null && home?.id == null) {
      return branches.first.id;
    }

    return preferredId ?? storedId;
  }

  Future<void> _updateHomeBranch() async {
    if (_selectedBranchId == null || _isUpdatingHomeBranch) return;
    final authCubit = context.read<AuthCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() {
      _isUpdatingHomeBranch = true;
    });

    final result = await authCubit.authRepository.setHomeBranch(
      homeBranchId: _selectedBranchId!,
    );

    if (!mounted) return;

    switch (result) {
      case ApiSuccess<bool>():
        Branch? selected;
        for (final branch in _branches) {
          if (branch.id == _selectedBranchId) {
            selected = branch;
            break;
          }
        }
        if (selected != null) {
          await authCubit.patchHomeBranch(
            UserHomeBranch(
              id: selected.id,
              name: selected.title,
              slug: null,
              code: selected.typeLabel.isNotEmpty ? selected.typeLabel : null,
            ),
          );
        } else {
          await authCubit.patchHomeBranch(
            UserHomeBranch(id: _selectedBranchId!),
          );
        }
        if (!mounted) return;
        setState(() {
          _isUpdatingHomeBranch = false;
        });
        messenger.showSnackBar(
          SnackBar(content: Text(context.l10n.updateHomeBranch)),
        );
        navigator.pop();
      case ApiFailure(:final exception):
        setState(() {
          _isUpdatingHomeBranch = false;
        });
        final message = (exception.message ?? '').trim().isNotEmpty
            ? exception.message!.trim()
            : context.l10n.somethingWentWrong;
        messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  bool get _isLoading => _awaitingLocation || _isLoadingBranches;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenTitle = widget.title?.isNotEmpty == true
        ? widget.title!
        : context.l10n.changeHomeBranch;
    final showUpdateButton =
        !widget.readOnly && _selectedBranchId != null;

    return Scaffold(
      appBar: AppAppBar(
        title: screenTitle,
        onBack: () => Navigator.of(context).pop(),
        isMoreMenu: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildBranchesContent(context),
                if (showUpdateButton)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: AppSpacing.md + 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
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
                if (showUpdateButton)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: AppSpacing.md,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: AppButton(
                        label: context.l10n.updateHomeBranch,
                        variant: AppButtonVariant.primary,
                        isLoading: _isUpdatingHomeBranch,
                        onPressed:
                            (_selectedBranchId == null ||
                                _isLoading ||
                                _isUpdatingHomeBranch)
                            ? null
                            : _updateHomeBranch,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchesContent(BuildContext context) {
    if (_isLoading) {
      return const AppLoadingIndicator();
    }

    if (_loadErrorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: AppSpacing.md,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_loadErrorMessage),
              SizedBox(height: AppSpacing.md),
              AppButton(
                label: context.l10n.retry,
                variant: AppButtonVariant.secondary,
                onPressed: _requestLocationAndLoadBranches,
              ),
            ],
          ),
        ),
      );
    }

    if (_branches.isEmpty) {
      return Center(child: Text(context.l10n.noBranchesAvailable));
    }

    final showUpdateButton =
        !widget.readOnly && _selectedBranchId != null;

    return RefreshIndicator(
      onRefresh: _requestLocationAndLoadBranches,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ..._branches.map(
                (branch) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.base),
                  child: BranchOption(
                    key: ValueKey('home_branch_${branch.id}'),
                    title: branch.title,
                    city: branch.city,
                    distance: BranchLocationUtils.distanceLabel(
                      branch,
                      userLat: _userLat,
                      userLng: _userLng,
                    ),
                    type: branch.typeLabel,
                    imageUrl: branch.imageUrl,
                    isOnBoarding: false,
                    selected: _selectedBranchId == branch.id,
                    onTap: widget.readOnly
                        ? () {}
                        : () => setState(() => _selectedBranchId = branch.id),
                  ),
                ),
              ),
              SizedBox(
                height: showUpdateButton
                    ? AppSpacing.xxxl * 2
                    : AppSpacing.xxxl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
