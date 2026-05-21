import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';

/// Shared indeterminate spinner color (dark brown — matches brand / tab loads).
abstract final class AppLoadingColors {
  static const Color indicator = AppColors.primary;
}

/// Internal spinner primitives — **do not use for blocking UI in features**.
/// Blocking loads: [BlockingLoadingOverlay] / [BlockingLoadingStack] only.
///
/// - [AppLoadingIndicator] — used by [BlockingLoadingOverlay]
/// - [AppInlineBusy] — tight non-blocking slots (if needed)
/// - [AppDeterminateProgressRing] — determinate ring (progress cards)
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.size, this.centered = true});

  /// जब दें तो स्पिनर उस साइज़ तक सीमित.
  final double? size;

  /// Wrap in [Center] for full-screen / tab loads (default). Set false inside fixed boxes.
  final bool centered;

  @override
  Widget build(BuildContext context) {
    Widget indicator = CircularProgressIndicator(
      strokeWidth: size != null && size! <= 24 ? 2.5 : 3,
      valueColor: const AlwaysStoppedAnimation<Color>(
        AppLoadingColors.indicator,
      ),
    );
    final s = size;
    if (s != null) {
      indicator = SizedBox(width: s, height: s, child: indicator);
    }
    if (!centered) return indicator;
    return Center(child: indicator);
  }
}

/// बटन या फिक्स्ड [SizedBox] के अंदर — [Center] नहीं.
class AppInlineBusy extends StatelessWidget {
  const AppInlineBusy({super.key, this.size = 22, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppLoadingColors.indicator,
        ),
      ),
    );
  }
}

/// डिटर्मिनेट रिंग (महीने का गोल %), इन्डिटर्मिनेट स्पिनर नहीं.
class AppDeterminateProgressRing extends StatelessWidget {
  const AppDeterminateProgressRing({
    super.key,
    required this.value,
    required this.isDark,
    this.constraints = const BoxConstraints(
      minHeight: 167,
      minWidth: 167,
      maxHeight: 167,
      maxWidth: 167,
    ),
    this.strokeWidth = 16,
  });

  final double? value;
  final bool isDark;
  final BoxConstraints constraints;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      backgroundColor: isDark
          ? AppColors.progressBGColor
          : AppColors.darkGreyBorder,
      constraints: constraints,
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(
        isDark ? AppColors.languageIconDark : AppColors.languageIcon,
      ),
    );
  }
}
