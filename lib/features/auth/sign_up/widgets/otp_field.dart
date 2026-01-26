import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';


class OtpField extends StatelessWidget {
  final int length;

  const OtpField({
    super.key,
    this.length = 6,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: length,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: InputDecoration(
        counterText: '',
        hintText: '• • • • • •',
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
