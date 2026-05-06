import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../widgets/app_shadow.dart';

class MonthlyTargetSlider extends StatefulWidget {
  const MonthlyTargetSlider({
    super.key,
    this.initialMonthlyClasses = 8,
    this.onMonthlyClassesChanged,
  });

  /// Snapped to {4, 8, 12, 16, 20, 24}.
  final int initialMonthlyClasses;

  /// Called when the value snaps to a new step.
  final ValueChanged<int>? onMonthlyClassesChanged;

  @override
  State<MonthlyTargetSlider> createState() => _MonthlyTargetSliderState();
}

class _MonthlyTargetSliderState extends State<MonthlyTargetSlider> {
  static const List<int> steps = [4, 8, 12, 16, 20, 24];

  late double value;

  @override
  void initState() {
    super.initState();
    value = _nearestStep(widget.initialMonthlyClasses.toDouble()).toDouble();
  }

  int _nearestStep(double raw) {
    return steps.reduce((a, b) => (raw - a).abs() <= (raw - b).abs() ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.classesPerMonth,
                style: (context) =>
                    AppTextStyles.textField(context).copyWith(height: 1),
              ),
              AppText(
                value.round().toString(),
                style: (context) => AppTextStyles.boldBody(
                  context,
                ).copyWith(fontSize: 18, height: 1),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          /// Slider Theme
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              padding: EdgeInsets.zero,
              trackHeight: 8,
              activeTrackColor: isDark
                  ? AppColors.primaryDarkButton
                  : AppColors.goalTrackColor,
              inactiveTrackColor: isDark
                  ? AppColors.primaryDarkButton
                  : AppColors.goalTrackColor,
              thumbColor: isDark
                  ? AppColors.languageIconDark
                  : AppColors.languageIcon,
              // overlayColor:   Colors.white,
              tickMarkShape: SliderTickMarkShape.noTickMark,

              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              min: 4,
              max: 24,
              divisions: 5,
              value: value,
              onChanged: (v) {
                final nearest = _nearestStep(v);
                setState(() => value = nearest.toDouble());
                widget.onMonthlyClassesChanged?.call(nearest);
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          /// Bottom numbers row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps
                .map(
                  (e) => AppText(
                    e.toString(),
                    style: (context) => AppTextStyles.captionText(
                      context,
                    ).copyWith(color: AppColors.lightGrey),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
