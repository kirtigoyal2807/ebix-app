import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

class EmptyDataView extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;

  const EmptyDataView({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(image),
        SizedBox(height: AppSpacing.lmd),
        AppText(
          title,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: (context) =>
              AppTextStyles.gelasioMedium(context).copyWith(height: 1.55),
        ),
        SizedBox(height: AppSpacing.xs),
        AppText(
          subTitle,
          textAlign: TextAlign.center,
          maxLines: 4,
          style: (context) =>
              AppTextStyles.bodyText(context).copyWith(height: 1.55),
        ),
      ],
    );
  }
}
