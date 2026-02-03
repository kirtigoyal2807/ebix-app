import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ClassTypesSection extends StatelessWidget {
  const ClassTypesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final types = [
      {'name': 'Reformer', 'image': 'https://images.unsplash.com/photo-1599447421416-3414502d18a5?q=80&w=2070&auto=format&fit=crop'},
      {'name': 'Cadillac', 'image': 'https://images.unsplash.com/photo-1599447421416-3414502d18a5?q=80&w=2070&auto=format&fit=crop'},
      {'name': 'Flow', 'image': 'https://images.unsplash.com/photo-1599447421416-3414502d18a5?q=80&w=2070&auto=format&fit=crop'},
    ];

    final itemWidth = size.width * 0.32 > 120 ? 120.0 : size.width * 0.32;
    final itemHeight = itemWidth * 0.83;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.classTypes,
                style: (context) => AppTextStyles.boldBody(context).copyWith(
                  fontSize: size.width * 0.045 > 18 ? 18 : size.width * 0.045,
                ),
              ),
              AppText(
                context.l10n.seeAll,
                style: (context) => AppTextStyles.captionText(context).copyWith(
                  color: Colors.grey,
                  fontSize: size.width * 0.03 > 12 ? 12 : size.width * 0.03,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
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
                      child: Image.network(
                        types[index]['image']!,
                        width: itemWidth,
                        height: itemHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      types[index]['name']!,
                      style: (context) => AppTextStyles.boldBody(context).copyWith(
                        fontSize: size.width * 0.035 > 14 ? 14 : size.width * 0.035,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.topTrainers,
                style: (context) => AppTextStyles.boldBody(context).copyWith(
                  fontSize: size.width * 0.045 > 18 ? 18 : size.width * 0.045,
                ),
              ),
              AppText(
                context.l10n.seeAll,
                style: (context) => AppTextStyles.captionText(context).copyWith(
                  color: Colors.grey,
                  fontSize: size.width * 0.03 > 12 ? 12 : size.width * 0.03,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
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
                  color: const Color(0xFFFDF2ED),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
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
                      style: (context) => AppTextStyles.boldBody(context).copyWith(
                        fontSize: size.width * 0.035 > 14 ? 14 : size.width * 0.035,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppText(
                      trainers[index]['type']!,
                      style: (context) => AppTextStyles.captionText(context).copyWith(
                        fontSize: size.width * 0.03 > 12 ? 12 : size.width * 0.03,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    AppText(
                      context.l10n.viewClasses,
                      style: (context) => AppTextStyles.captionText(context).copyWith(
                        color: const Color(0xFFC48B71),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: size.width * 0.03 > 12 ? 12 : size.width * 0.03,
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
