import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_colors.dart';

class SwitchWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  final bool switchValue;
  final void Function(bool)? onChanged;

  SwitchWidget({
    super.key,
    required this.switchValue,
    required this.onChanged,
    required this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              style: (context) =>
                  AppTextStyles.textFieldHeading(context).copyWith(
                    fontSize: 15,
                    height: 1.60,
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                  ),
            ),

            if (subTitle != null) SizedBox(height: 2),
            if (subTitle != null)
              AppText(
                subTitle ?? "",
                style: (context) => AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.lightGrey, height: 1.60),
              ),
          ],
        ),

        Transform.scale(
          scale: 0.8, // 👈 reduce overall size (try 0.7–0.9)
          child: CupertinoSwitch(
            value: switchValue,
            onChanged: onChanged,
            // activeColor:
            // isDark ? AppColors.switchInactiveDark : AppColors.primary,
            inactiveThumbColor: isDark
                ? AppColors.primary
                : AppColors.whiteColor,
            inactiveTrackColor: isDark
                ? Color(0xff1C1917)
                : AppColors.buttonBorder,
            activeTrackColor: isDark ? AppColors.primary : AppColors.primary,
            // trackColor: isDark
            //     ? AppColors.switchInactiveDark
            //     : AppColors.buttonBorder,
            thumbColor: isDark ? AppColors.lightText : AppColors.whiteColor,
          ),
        ),
      ],
    );
  }
}
