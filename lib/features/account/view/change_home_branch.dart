import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
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
  int _selectedIndex = 0;

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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BranchOption(
                      title: 'Balad, Al Al Munawarah',
                      city: 'Al Madinah Al Munawarah',
                      distance: '5 km away',
                      type: 'Premium',
                      selected: !widget.readOnly && _selectedIndex == 0,
                      isOnBoarding: false,
                      onTap: widget.readOnly ? () {} : () => setState(() => _selectedIndex = 0),
                    ),
                    SizedBox(
                      height: AppSpacing.base,
                    ),
                    BranchOption(
                      title: 'Balad, Al Al Munawarah',
                      city: 'Al Madinah Al Munawarah',
                      distance: '5 km away',
                      type: 'Premium',
                      isOnBoarding: false,
                      selected: !widget.readOnly && _selectedIndex == 1,
                      onTap: widget.readOnly ? () {} : () => setState(() => _selectedIndex = 1),
                    ),
                    SizedBox(
                      height: AppSpacing.base,
                    ),
                    BranchOption(
                      title: 'Balad, Al Al Munawarah',
                      city: 'Al Madinah Al Munawarah',
                      distance: '5 km away',
                      type: 'Premium',
                      isOnBoarding: false,
                      selected: !widget.readOnly && _selectedIndex == 2,
                      onTap: widget.readOnly ? () {} : () => setState(() => _selectedIndex = 2),
                    ),
                
                
                
                
                  ],
                ),
              ),
            ),
            if (!widget.readOnly)
              AppButton(
                label: context.l10n.updateHomeBranch,
                variant: AppButtonVariant.primary,
                onPressed: () {},
              )
          ],
        ),
      ),
    );
  }
}
