import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/data/models/trainer_resource.dart';
import 'package:pilates_app/features/home/data/models/home_response.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../cubit/home_cubit.dart';
import '../../booking/views/trainer_details_view.dart';

class ClassTypesSection extends StatelessWidget {
  const ClassTypesSection({super.key, required this.classTypes});

  final List<HomeClassType> classTypes;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    if (classTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: classTypes.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (BuildContext context, int index) {
              final classType = classTypes[index];
              return GestureDetector(
                onTap: () => context.read<HomeCubit>().setTab(
                  1,
                  classCategory: (classType.name ?? '').trim(),
                ),
                child: SizedBox(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Image.network(
                          classType.imageUrl ?? '',
                          width: 140,
                          height: 105,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) => Image.asset(
                                'assets/images/demo images/ic_table.png',
                                width: 140,
                                height: 105,
                                fit: BoxFit.cover,
                              ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base),
                      AppText(
                        classType.name ?? '',
                        style: (context) =>
                            AppTextStyles.heading1(context).copyWith(
                              fontSize: size.width * 0.035 > 14
                                  ? 14
                                  : size.width * 0.035,
                              color: isDark
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TopTrainersSection extends StatelessWidget {
  const TopTrainersSection({super.key, required this.trainers});

  final List<HomeTrainer> trainers;

  TrainerResource _toTrainerResource(HomeTrainer trainer) {
    return TrainerResource(
      id: (trainer.id ?? '').trim(),
      displayName: trainer.displayName ?? '',
      specialties: trainer.specialties,
      certifications: const [],
      branches: const [],
      avatarUrl: trainer.imageUrl,
      avgRating: trainer.avgRating,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    if (trainers.isEmpty) {
      return const SizedBox.shrink();
    }

    final itemWidth = size.width * 0.38 > 140 ? 140.0 : size.width * 0.38;
    const itemHeight = 172.0;
    final pad = itemWidth * 0.08;

    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        itemCount: trainers.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (BuildContext context, int index) {
          final trainer = trainers[index];
          final subtitle = trainer.specialties.isEmpty
              ? (trainer.avgRating == null ? '' : '★ ${trainer.avgRating}')
              : trainer.specialties.join(', ');
          return SizedBox(
            width: itemWidth,
            height: itemHeight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainerDetailsView(
                      trainer: _toTrainerResource(trainer),
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(pad),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.trainerBlackBackgroundColor
                      : AppColors.seekBarLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: itemWidth * 0.20,
                              backgroundColor: isDark
                                  ? AppColors.homeBackground
                                  : AppColors.whiteColor,
                              backgroundImage:
                                  (trainer.imageUrl ?? '').trim().isEmpty
                                  ? null
                                  : NetworkImage(trainer.imageUrl!),
                              child: (trainer.imageUrl ?? '').trim().isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            AppText(
                              trainer.displayName ?? '',
                              style: (context) =>
                                  AppTextStyles.heading1(context).copyWith(
                                    fontSize: 16,
                                    height: 1.15,
                                    color: isDark
                                        ? AppColors.lightText
                                        : AppColors.darkText,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              subtitle,
                              style: (context) =>
                                  AppTextStyles.captionText(context).copyWith(
                                    fontSize: 12,
                                    height: 1.2,
                                    color: isDark
                                        ? AppColors.languageIconDark
                                        : AppColors.lightGrey,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xi),
                      child: AppText(
                        context.l10n.viewClasses,
                        style: (context) =>
                            AppTextStyles.captionText(context).copyWith(
                              color: isDark
                                  ? AppColors.versionColor
                                  : AppColors.languageIcon,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              height: 1.15,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
