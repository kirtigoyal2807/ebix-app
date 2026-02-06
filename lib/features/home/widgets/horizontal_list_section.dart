import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ClassTypesSection extends StatelessWidget {
  const ClassTypesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final types = [
      {'name': 'Reformer', 'image': 'assets/images/svg/ic_table.svg'},
      {'name': 'Cadillac', 'image': 'assets/images/svg/ic_table.svg'},
      {'name': 'Flow', 'image': 'assets/images/svg/ic_table.svg'},
    ];

    final itemWidth = size.width * 0.32 > 120 ? 120.0 : size.width * 0.32;
    final itemHeight = itemWidth * 0.83;

    return Column(
      children: [
        SizedBox(
          height: itemHeight + 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: types.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              return SizedBox(
                width: itemWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: SvgPicture.asset(
                        types[index]['image']!,
                        width: itemWidth,
                        height: itemHeight,
                        fit: BoxFit.cover,
                      ),

                    ),
                    const SizedBox(height: AppSpacing.xs),
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
      {'name': 'Lena Hart', 'type': 'Grounded Flow', 'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1976&auto=format&fit=crop'},
      {'name': 'Lena Hart', 'type': 'Grounded Flow', 'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1976&auto=format&fit=crop'},
      {'name': 'Lena Hart', 'type': 'Grounded Flow', 'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1976&auto=format&fit=crop'},
    ];

    final itemWidth = size.width * 0.38 > 140 ? 140.0 : size.width * 0.38;
    final itemHeight = itemWidth * 1.3 > 180 ? 180.0 : itemWidth * 1.3;

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
                padding: EdgeInsets.all(itemWidth * 0.1),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.trainerBlackBackgroundColor: AppColors.seekBarLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: itemWidth * 0.22,
                      backgroundImage: NetworkImage(trainers[index]['image']!),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      trainers[index]['name']!,
                      style: (context) => AppTextStyles.heading1(context).copyWith(
                        fontSize: size.width * 0.035 > 14 ? 14 : size.width * 0.035,
                        color: isDark
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppText(
                      trainers[index]['type']!,
                      style: (context) => AppTextStyles.captionText(context).copyWith(
                        fontSize: size.width * 0.03 > 12 ? 12 : size.width * 0.03,
                        color: isDark
                            ? AppColors.languageIconDark
                            : AppColors.lightGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppText(
                      context.l10n.viewClasses,
                      style: (context) => AppTextStyles.captionText(context).copyWith(
                        color: isDark
                            ? AppColors.versionColor
                            : AppColors.languageIcon,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
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
