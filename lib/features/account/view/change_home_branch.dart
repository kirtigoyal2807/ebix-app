import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';

import '../../auth/sign_up/widgets/branch_option.dart';

class ChangeHomeBranch extends StatefulWidget {
  const ChangeHomeBranch({super.key});

  @override
  State<ChangeHomeBranch> createState() => _ChangeHomeBranchState();
}

class _ChangeHomeBranchState extends State<ChangeHomeBranch> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.changeHomeBranch,
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
                      selected: _selectedIndex == 0,
                      isOnBoarding: false,
                      onTap: () => setState(() => _selectedIndex = 0),
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
                      selected: _selectedIndex == 1,
                      onTap: () => setState(() => _selectedIndex = 1),
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
                      selected: _selectedIndex == 2,
                      onTap: () => setState(() => _selectedIndex = 2),
                    ),
                
                
                
                
                  ],
                ),
              ),
            ),
            AppButton(label: context.l10n.updateHomeBranch,variant: AppButtonVariant.primary,onPressed: () {

            },)
          ],
        ),
      ),
    );
  }
}
