import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/widgets/tag_chip.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_radius.dart';
import '../../../widgets/app_shadow.dart';
import '../data/models/trainer_resource.dart';
import 'trainer_average_stars.dart';
import '../cubit/booking_cubit.dart';
import '../views/trainer_details_view.dart';

class TrainerCard extends StatelessWidget {
  const TrainerCard({super.key, required this.trainer});

  final TrainerResource trainer;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final titleSize = size.width * 0.04 > 16 ? 16.0 : size.width * 0.04;
    final metaSize = size.width * 0.03 > 14 ? 14.0 : size.width * 0.03;
    final subtitle = trainer.specialties.take(5).join(' · ');

    return GestureDetector(
      onTap: () {
        final bookingCubit = context.read<BookingCubit>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) => BlocProvider.value(
              value: bookingCubit,
              child: TrainerDetailsView(trainer: trainer),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lmd,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
          border: Border.all(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            width: 0.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  AppShadows.lightShadow,
                  AppShadows.mediumShadow,
                  AppShadows.mediumHeavyShadow,
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.01),
                    offset: const Offset(0, 64),
                    blurRadius: 25,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.00),
                    offset: const Offset(0, 99),
                    blurRadius: 28,
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TrainerAvatar(trainer: trainer),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppText(
                          trainer.displayName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: (context) =>
                              AppTextStyles.boldBody(context).copyWith(
                                fontSize: titleSize,
                                height: 1.2,
                                color: isDark
                                    ? AppColors.lightText
                                    : AppColors.darkText,
                              ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: _TrainerRatingRow(
                            trainer: trainer,
                            isDark: isDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.sm),
                    AppText(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: (context) =>
                          AppTextStyles.captionText(context).copyWith(
                            fontSize: metaSize,
                            color: isDark
                                ? AppColors.darkGreyText
                                : AppColors.lightGrey,
                          ),
                    ),
                  ],
                  SizedBox(height: AppSpacing.base),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      if (trainer.yearsExperience != null)
                        TagChip(
                          label: context.l10n.yearsExperience(
                            trainer.yearsExperience!,
                          ),
                          fontSize: 14,
                        ),
                      for (final s in trainer.specialties.take(3))
                        TagChip(label: s, fontSize: 14),
                    ],
                  ),
                  if (trainer.bio != null &&
                      trainer.bio!.trim().isNotEmpty) ...[
                    SizedBox(height: AppSpacing.sm),
                    AppText(
                      trainer.bio!.trim(),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: (context) =>
                          AppTextStyles.bodyText(context).copyWith(height: 1.4),
                    ),
                  ],
                  if (trainer.branches.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.sm),
                    _buildIconRow(
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: isDark
                            ? AppColors.languageIconDark
                            : AppColors.languageIcon,
                        size: 16,
                      ),
                      label: trainer.branches.map((b) => b.name).join(', '),
                    ),
                  ],
                  if (trainer.classesThisWeekCount != null) ...[
                    SizedBox(height: AppSpacing.sm),
                    _buildIconRow(
                      icon: SvgPicture.asset(
                        "assets/images/svg/ic_physical_therapy.svg",
                        height: 16,
                        width: 16,
                        color: isDark
                            ? AppColors.languageIconDark
                            : AppColors.languageIcon,
                      ),
                      label: context.l10n.classesThisWeek(
                        trainer.classesThisWeekCount!,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconRow({required Widget icon, required String label}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 1), child: icon),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: AppText(
            label,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: (context) =>
                AppTextStyles.bodyText(context).copyWith(height: 1.3),
          ),
        ),
      ],
    );
  }
}

/// List card: uses API [avgRating] / [reviewsCount] only — no placeholder averages.
class _TrainerRatingRow extends StatelessWidget {
  const _TrainerRatingRow({required this.trainer, required this.isDark});

  final TrainerResource trainer;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final count = trainer.reviewsCount;
    final metaColor = isDark ? AppColors.darkGreyText : AppColors.lightGrey;
    final avgValue = trainer.averageRatingValue;
    final avgText = trainer.displayAverageRating;

    if (avgValue != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TrainerAverageStars(rating: avgValue, itemSize: 13),
          const SizedBox(width: 6),
          AppText(
            avgText.isNotEmpty ? avgText : avgValue.toStringAsFixed(1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (context) => AppTextStyles.boldBody(context).copyWith(
              color: isDark ? AppColors.lightText : AppColors.darkText,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 2),
            AppText(
              '($count)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (context) => AppTextStyles.captionText(context),
            ),
          ],
        ],
      );
    }

    if (avgText.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_border_rounded, color: metaColor, size: 18),
          const SizedBox(width: 4),
          AppText(
            avgText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (context) => AppTextStyles.boldBody(context).copyWith(
              color: isDark ? AppColors.lightText : AppColors.darkText,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 2),
            AppText(
              '($count)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (context) => AppTextStyles.captionText(context),
            ),
          ],
        ],
      );
    }

    if (count > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_border_rounded, color: metaColor, size: 18),
          const SizedBox(width: 4),
          AppText(
            '($count)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (context) => AppTextStyles.captionText(context),
          ),
        ],
      );
    }

    return Icon(Icons.star_border_rounded, color: metaColor, size: 18);
  }
}

class _TrainerAvatar extends StatelessWidget {
  const _TrainerAvatar({required this.trainer});

  final TrainerResource trainer;

  @override
  Widget build(BuildContext context) {
    final url = trainer.avatarUrl;
    if (url != null && url.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url,
          height: 56,
          width: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Image.asset(
            'assets/images/demo images/Trainer Avatar.png',
            height: 56,
            width: 56,
          ),
        ),
      );
    }
    return ClipOval(
      child: Image.asset(
        'assets/images/demo images/Trainer Avatar.png',
        height: 56,
        width: 56,
        fit: BoxFit.cover,
      ),
    );
  }
}
