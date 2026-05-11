import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int index;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? Theme.of(context).colorScheme.primary
                : AppColors.disabled,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
