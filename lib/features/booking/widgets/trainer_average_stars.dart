import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:pilates_app/config/theme/app_colors.dart';

/// Read-only 0–5 star row for API `avgRating` (e.g. 4.2 → four full + partial).
class TrainerAverageStars extends StatelessWidget {
  const TrainerAverageStars({
    super.key,
    required this.rating,
    this.itemSize = 16,
  });

  final double rating;
  final double itemSize;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unrated = isDark ? AppColors.darkGreyText : AppColors.lightGrey;
    return RatingBarIndicator(
      rating: rating.clamp(0, 5),
      itemSize: itemSize,
      itemCount: 5,
      textDirection: TextDirection.ltr,
      itemPadding: EdgeInsets.zero,
      unratedColor: unrated,
      itemBuilder: (context, _) => const Icon(
        Icons.star_rounded,
        color: AppColors.goldStarColor,
      ),
    );
  }
}
