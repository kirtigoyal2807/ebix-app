import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';

/// Sign-up horizontal progress (always fills left-to-right for visual consistency).
class SignUpProgress extends StatefulWidget {
  final int currentStep;
  final int totalSteps;

  const SignUpProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  State<SignUpProgress> createState() => _SignUpProgressState();
}

class _SignUpProgressState extends State<SignUpProgress>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 600);

  late final AnimationController _controller = AnimationController(
    duration: _animationDuration,
    vsync: this,
  );

  late Animation<double> _progressAnimation;

  double get _target =>
      widget.totalSteps > 0 ? (widget.currentStep + 1) / widget.totalSteps : 0;

  Animation<double> _tweenBetween(double begin, double end) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void initState() {
    super.initState();
    _progressAnimation = _tweenBetween(0, _target.clamp(0.0, 1.0));
    _controller.forward();
  }

  @override
  void didUpdateWidget(SignUpProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep == oldWidget.currentStep &&
        widget.totalSteps == oldWidget.totalSteps) {
      return;
    }
    final begin = _progressAnimation.value.clamp(0.0, 1.0);
    final end = _target.clamp(0.0, 1.0);
    if ((begin - end).abs() < 0.001) {
      return;
    }
    _controller.reset();
    _progressAnimation = _tweenBetween(begin, end);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, _) => LinearProgressIndicator(
            value: _progressAnimation.value.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: isDark
                ? AppColors.primaryDarkButton
                : AppColors.ratingBarBackground,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? AppColors.languageIconDark : AppColors.languageIconDark,
            ),
          ),
        ),
      ),
    );
  }
}
