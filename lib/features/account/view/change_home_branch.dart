import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';

import '../../auth/sign_up/widgets/branch_option.dart';

class ChangeHomeBranch extends StatefulWidget {
  const ChangeHomeBranch({
    super.key,
    this.title,
    this.readOnly = false,
  });

  final String? title;
  final bool readOnly;

  @override
  State<ChangeHomeBranch> createState() => _ChangeHomeBranchState();
}

class _ChangeHomeBranchState extends State<ChangeHomeBranch> {
  bool _isLoadingBranches = true;
  bool _isUpdatingHomeBranch = false;
  String _loadErrorMessage = '';
  List<Branch> _branches = const [];
  int? _selectedBranchId;

  @override
  void initState() {
    super.initState();
    _fetchBranches();
  }

  Future<void> _fetchBranches() async {
    setState(() {
      _isLoadingBranches = true;
      _loadErrorMessage = '';
    });

    final result = await context.read<AuthCubit>().authRepository.listBranches(
      queryParameters: const {'page': 1, 'per_page': 50},
    );

    if (!mounted) return;

    switch (result) {
      case ApiSuccess(:final data):
        setState(() {
          _branches = data.branches;
          _isLoadingBranches = false;
          if (_branches.isNotEmpty) {
            _selectedBranchId ??= _branches.first.id;
          }
        });
      case ApiFailure(:final exception):
        setState(() {
          _isLoadingBranches = false;
          _loadErrorMessage =
              (exception.message ?? '').trim().isNotEmpty
              ? exception.message!.trim()
              : context.l10n.branchesCouldNotLoad;
        });
    }
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
        setState(() {
          _isUpdatingHomeBranch = false;
        });
        await authCubit.loadProfile();
        if (!mounted) return;
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
        messenger.showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = widget.title?.isNotEmpty == true
        ? widget.title!
        : context.l10n.changeHomeBranch;

    return Scaffold(
      appBar: AppAppBar(
        title: screenTitle,
        onBack: () => Navigator.of(context).pop(),
        isMoreMenu: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        child: Column(
          children: [
            Expanded(
              child: _buildBranchesContent(context),
            ),
            if (!widget.readOnly)
              AppButton(
                label: context.l10n.updateHomeBranch,
                variant: AppButtonVariant.primary,
                isLoading: _isUpdatingHomeBranch,
                onPressed: (_selectedBranchId == null ||
                        _isLoadingBranches ||
                        _isUpdatingHomeBranch)
                    ? null
                    : _updateHomeBranch,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchesContent(BuildContext context) {
    if (_isLoadingBranches) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadErrorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_loadErrorMessage),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: context.l10n.retry,
              variant: AppButtonVariant.secondary,
              onPressed: _fetchBranches,
            ),
          ],
        ),
      );
    }

    if (_branches.isEmpty) {
      return Center(
        child: Text(context.l10n.noBranchesAvailable),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _branches
            .map(
              (branch) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.base),
                child: BranchOption(
                  title: branch.title,
                  city: branch.city,
                  distance: branch.distance,
                  type: branch.typeLabel,
                  imageUrl: branch.imageUrl,
                  isOnBoarding: false,
                  selected: _selectedBranchId == branch.id,
                  onTap: widget.readOnly
                      ? () {}
                      : () => setState(() => _selectedBranchId = branch.id),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
