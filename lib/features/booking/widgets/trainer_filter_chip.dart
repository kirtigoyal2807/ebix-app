import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/booking/cubit/booking_cubit.dart';
import 'package:pilates_app/features/booking/cubit/booking_state.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';

class TrainerFilterChip extends StatelessWidget {
  const TrainerFilterChip({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return SizedBox(
          height: 28,
          child: ListView.separated(
            itemCount: state.trainerTypeList.length,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              bool isSelected =
                  state.selectedTrainerType == state.trainerTypeList[index];

              return GestureDetector(
                onTap: () {
                  context.read<BookingCubit>().setTrainer(
                    state.trainerTypeList[index],
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.base,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isDark
                        ? AppColors.primaryDarkButton
                        : AppColors.greyContainerBg,
                    borderRadius: BorderRadius.circular(AppRadius.base),
                  ),
                  child: AppText(
                    getTrainer(context, state.trainerTypeList[index]),
                    style: (context) =>
                        AppTextStyles.textFieldHeading(context).copyWith(
                          color: isSelected || isDark
                              ? Colors.white
                              : AppColors.darkText,
                        ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String getTrainer(BuildContext context, TrainerType trainerType) {
    switch (trainerType) {
      case TrainerType.allTrainers:
        return context.l10n.allTrainers;

      case TrainerType.matPilates:
        return context.l10n.matPilates;

      case TrainerType.reformer:
        return context.l10n.reformer;

      case TrainerType.seniorFriendly:
        return context.l10n.seniorFriendly;
    }
  }
}
