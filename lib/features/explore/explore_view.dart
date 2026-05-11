import 'package:flutter/material.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';

import 'package:pilates_app/features/explore/view/discover_info.dart';
import 'package:pilates_app/features/explore/view/help_about_info.dart';
import 'package:pilates_app/features/explore/view/my_activity_info.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';

import '../../core/localization/localization_extension.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(title: context.l10n.explore, isMoreMenu: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiscoverInfo(),
              SizedBox(height: AppSpacing.xl),
              MyActivityInfo(),
              SizedBox(height: AppSpacing.xl),
              HelpAboutInfo(),

              SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
      ),
    );
  }
}
