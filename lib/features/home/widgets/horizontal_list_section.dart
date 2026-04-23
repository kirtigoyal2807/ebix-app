import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../booking/views/trainer_details_view.dart';

class ClassTypesSection extends StatelessWidget {
  const ClassTypesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final types = [
      {'name': context.l10n.classTypeReformer, 'image': 'assets/images/demo images/ic_table.png'},
      {'name': context.l10n.classTypeCadillac, 'image': 'assets/images/demo images/ic_table.png'},
      {'name': context.l10n.classTypeFlow, 'image': 'assets/images/demo images/ic_table.png'},
    ];

    final itemWidth = size.width * 0.45;
    final itemHeight = itemWidth * 0.65;

    return Column(
      children: [
        SizedBox(
          height: 135,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: types.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Image.asset(
                        types[index]['image']!,
                        width: 140,
                        height: 105,
                        // width: itemWidth,
                        // height: itemHeight,
                        fit: BoxFit.cover,
                      ),

                    ),
                    const SizedBox(height: AppSpacing.base),
                    AppText(
                      types[index]['name']!,
                      style: (context) => AppTextStyles.heading1(context).copyWith(
                        fontSize: size.width * 0.035 > 14 ? 14 : size.width * 0.035,
                        color: isDark
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
  const TopTrainersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final trainers = [
      {'name': 'Lena Hart', 'type': context.l10n.trainerGroundedFlow, 'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1976&auto=format&fit=crop'},
      {'name': 'Lena Hart', 'type': context.l10n.trainerGroundedFlow, 'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1976&auto=format&fit=crop'},
      {'name': 'Lena Hart', 'type': context.l10n.trainerGroundedFlow, 'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1976&auto=format&fit=crop'},
    ];

    final itemWidth = size.width * 0.38 > 140 ? 140.0 : size.width * 0.38;
    final verticalPadding = (itemWidth * 0.08).clamp(8.0, 14.0);
    final avatarRadius = (itemWidth * 0.20).clamp(22.0, 28.0);
    // Tall enough for avatar + 2 text lines + link without vertical overflow.
    final itemHeight = (avatarRadius * 2 + verticalPadding * 2 + 120).clamp(188.0, 230.0);

    return Column(
      children: [
        SizedBox(
          height: itemHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: trainers.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              return Container(
                width: itemWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: itemWidth * 0.08,
                  vertical: verticalPadding,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.trainerBlackBackgroundColor: AppColors.seekBarLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: NetworkImage(trainers[index]['image']!),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      trainers[index]['name']!,
                      style: (context) => AppTextStyles.heading1(context).copyWith(
                        fontSize: 16,
                        height: 1.2,
                        color: isDark
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      trainers[index]['type']!,
                      style: (context) => AppTextStyles.captionText(context).copyWith(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.languageIconDark
                            : AppColors.lightGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrainerDetailsView()),
                        );
                      },
                      child: AppText(
                        context.l10n.viewClasses,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: (context) => AppTextStyles.captionText(context).copyWith(
                          color: isDark
                              ? AppColors.versionColor
                              : AppColors.languageIcon,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
