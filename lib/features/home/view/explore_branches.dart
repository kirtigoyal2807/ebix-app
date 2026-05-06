import 'dart:math';

import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_spacing.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_app_bar.dart';
import '../../auth/sign_up/widgets/branch_option.dart';

class ExploreBranches extends StatelessWidget {
  const ExploreBranches({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      appBar: AppAppBar(
        title: l10n.branches,
        isMoreMenu: false,
        onBack: () {
          Navigator.of(context).pop();
          // context.pop();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            children: [
              BranchOption(
                title: 'Balad, Al Al Munawarah',
                city: 'Al Madinah Al Munawarah',
                distance: '5 km away',
                type: 'Premium',
                selected: false,
                onTap: () {},
              ),

              const SizedBox(height: AppSpacing.md),

              BranchOption(
                title: 'Prince Abdul Majeed Street',
                city: 'Al Madinah Al Munawarah',
                distance: '8 km away',
                type: 'Standard',
                selected: false,
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.md),
              BranchOption(
                title: 'Balad, Al Al Munawarah',
                city: 'Al Madinah Al Munawarah',
                distance: '5 km away',
                type: 'Premium',
                selected: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
