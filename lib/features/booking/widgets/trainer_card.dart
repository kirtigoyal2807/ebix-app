import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/widgets/no_reviews_yet_row.dart';
import 'package:pilates_app/features/booking/widgets/tag_chip.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../widgets/app_shadow.dart';
import '../cubit/booking_cubit.dart';
import '../data/models/trainer_resource.dart';
import '../views/trainer_details_view.dart';

class TrainerCard extends StatelessWidget {
  const TrainerCard({super.key, required this.trainer});

  final TrainerResource trainer;

  static const _avatarSize = 56.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitle = trainer.specialties.isNotEmpty
        ? trainer.specialties.first
        : null;
    final tagLabels = _tagLabels(context);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TrainerAvatar(trainer: trainer),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        trainer.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: (context) => AppTextStyles.boldBody(context)
                            .copyWith(
                              fontSize: 14,
                              height: 1.25,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                            ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: AppSpacing.xs),
                        AppText(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: (context) => AppTextStyles.bodyText(context)
                              .copyWith(
                                height: 1.3,
                                color: isDark
                                    ? AppColors.darkGreyText
                                    : AppColors.lightGrey,
                              ),
                        ),
                      ],
                      SizedBox(height: AppSpacing.xs),
                      _TrainerRatingRow(trainer: trainer, isDark: isDark),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xi),
            if (tagLabels.isNotEmpty)

              Column(
                children: [
                  SizedBox(height: AppSpacing.base),
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final label in tagLabels)
                        TagChip(
                          label: label,
                          fontSize: 14,
                          pillShape: true,
                          constrainWidth: false,
                        ),
                    ],
                  ),
                ],
              ),
            if (trainer.bio != null && trainer.bio!.trim().isNotEmpty) ...[
              SizedBox(height: AppSpacing.sm),
              AppText(
                trainer.bio!.trim(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: (context) => AppTextStyles.bodyText(context).copyWith(
                  fontSize: 12,
                  height: 1.4,
                  color: isDark
                      ? AppColors.darkGreyText
                      : AppColors.lightGrey,
                ),
              ),
            ],
            if (trainer.branches.isNotEmpty) ...[
              SizedBox(height: AppSpacing.sm),
              _LocationRow(
                label: trainer.branches.map((b) => b.name).join(', '),
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Same sources as trainer details tags: experience + specialties (list capped at 3).
  List<String> _tagLabels(BuildContext context) {
    final labels = <String>[];

    final years = trainer.yearsExperience;
    if (years != null) {
      labels.add(context.l10n.yearsExperience(years));
    }

    for (final s in trainer.specialties.take(3)) {
      final t = s.trim();
      if (t.isEmpty || labels.contains(t)) continue;
      labels.add(t);
    }

    return labels;
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(
            Icons.location_on_outlined,
            color: isDark ? AppColors.languageIconDark : AppColors.languageIcon,
            size: 16,
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: AppText(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: (context) => AppTextStyles.bodyText(context).copyWith(
              fontSize: 12,
              height: 1.3,
              color: isDark ? AppColors.darkGreyText : AppColors.greyText,
            ),
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
    final avgValue = trainer.averageRatingValue;
    final avgText = trainer.displayAverageRating;

    if (avgValue == null && avgText.isEmpty) {
      if (count > 0) {
        return _ratingShell(
          child: AppText(
            '($count ${context.l10n.reviews})',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (context) => AppTextStyles.bodyText(context).copyWith(
              height: 1,
              color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
            ),
          ),
        );
      }
      return const NoReviewsYetRow(center: false);
    }

    final ratingLabel = avgValue != null
        ? (avgText.isNotEmpty ? avgText : avgValue.toStringAsFixed(1))
        : avgText;

    return _ratingShell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            ratingLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (context) => AppTextStyles.boldBody(context).copyWith(
              fontSize: 14,
              height: 1,
              color: isDark ? AppColors.lightText : AppColors.darkText,
            ),
          ),
          if (count > 0) ...[
            SizedBox(width: AppSpacing.xs),
            AppText(
              '($count)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (context) => AppTextStyles.bodyText(context).copyWith(
                height: 1,
                color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _ratingShell({required Widget child}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.star, color: AppColors.goldStarColor, size: 16),
        SizedBox(width: AppSpacing.xs),
        Flexible(child: child),
      ],
    );
  }
}

class _TrainerAvatar extends StatelessWidget {
  const _TrainerAvatar({required this.trainer});

  final TrainerResource trainer;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.greyText : AppColors.buttonBorder;

    Widget image;
    final url = trainer.avatarUrl;
    if (url != null && url.isNotEmpty) {
      image = Image.network(
        url,
        height: TrainerCard._avatarSize,
        width: TrainerCard._avatarSize,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Image.asset(
          'assets/images/demo images/Trainer Avatar.png',
          height: TrainerCard._avatarSize,
          width: TrainerCard._avatarSize,
          fit: BoxFit.cover,
        ),
      );
    } else {
      image = Image.asset(
        'assets/images/demo images/Trainer Avatar.png',
        height: TrainerCard._avatarSize,
        width: TrainerCard._avatarSize,
        fit: BoxFit.cover,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: ClipOval(child: image),
    );
  }
}
