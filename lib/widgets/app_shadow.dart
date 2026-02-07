import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';

class AppShadows {
  static final lightShadow = BoxShadow(
    color: AppColors.shadowColor.withValues(alpha: 0.05),
    offset: const Offset(0, 4),
    blurRadius: 9,
    spreadRadius: 0,
  );

  static final mediumShadow = BoxShadow(
    color: AppColors.shadowColor.withValues(alpha: 0.04),
    offset: const Offset(0, 16),
    blurRadius: 16,
    spreadRadius: 0,
  );

  static final mediumHeavyShadow = BoxShadow(
    color: AppColors.shadowColor.withValues(alpha: 0.03),
    offset: const Offset(0, 36),
    blurRadius: 21,
    spreadRadius: 0,
  );

  static final heavyShadow = BoxShadow(
    color: AppColors.shadowColor.withValues(alpha: 0.03),
    offset: const Offset(0, 64),
    blurRadius: 25,
    spreadRadius: 0,
  );
  static final extraHeavyShadow = BoxShadow(
    color: AppColors.shadowColor.withValues(alpha: 0.03),
    offset: const Offset(0, 99),
    blurRadius: 28,
    spreadRadius: 0,
  );
}
