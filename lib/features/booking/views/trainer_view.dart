import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_spacing.dart';
import '../../../core/localization/localization_extension.dart';
import '../widgets/booking_search_bar.dart';
import '../widgets/trainer_card.dart';
import '../widgets/trainer_filter_chip.dart';

class TrainerView extends StatelessWidget {
  const TrainerView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      children: [
          BookingSearchBar(hintText: context.l10n.searchTrainers),
        const SizedBox(height: AppSpacing.md),
        const TrainerFilterChip(),
        const SizedBox(height: AppSpacing.md),
        Divider(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          height: 1,
        ),
        const SizedBox(height: AppSpacing.lg),
        TrainerCard(),
        const SizedBox(height: AppSpacing.md),
        TrainerCard(),
      ],
    );
  }
}
