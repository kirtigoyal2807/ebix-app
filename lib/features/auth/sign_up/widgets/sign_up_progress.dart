import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_radius.dart';

class SignUpProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SignUpProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 6,
        backgroundColor: Theme.of(context).dividerColor,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
