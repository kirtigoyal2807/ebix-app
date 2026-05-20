import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

/// Empty reviews placeholder: star icon + [noReviewsYet] label.
class NoReviewsYetRow extends StatelessWidget {
  const NoReviewsYetRow({super.key, this.center = true});

  final bool center;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkGreyText : AppColors.lightGrey;

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.star, size: 16, color: color),
        SizedBox(width: AppSpacing.xs),
        AppText(
          context.l10n.noReviewsYet,
          maxLines: 1,
          style: (c) => AppTextStyles.bodyText(c).copyWith(
            fontSize: 12,
            color: color,
            height: 1.2,
          ),
        ),
      ],
    );

    if (center) {
      return Center(child: row);
    }
    return row;
  }
}
