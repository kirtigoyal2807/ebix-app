import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

/// Formats remaining cooldown as `m:ss` (e.g. `0:30`).
String formatOtpResendCooldownTimer(Duration remaining) {
  final seconds = remaining.inSeconds.clamp(0, 3599);
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

/// "Didn't receive code?" plus [resendCode] / cooldown row with theme-specific colors and RTL-safe timer.
class OtpResendAction extends StatelessWidget {
  const OtpResendAction({
    super.key,
    required this.isOnCooldown,
    required this.cooldownRemaining,
    required this.resendGestureDisabled,
    required this.onResend,
  });

  final bool isOnCooldown;
  final Duration cooldownRemaining;
  /// True when tap should be ignored (loading, blocking overlay, or cooldown).
  final bool resendGestureDisabled;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = context.l10n;

    final mutedResendAndIn =
        isDark ? AppColors.lightGrey : AppColors.darkGreyText;
    final timerAndActiveResend = isDark
        ? AppColors.languageTextDark
        : AppColors.languageIcon;

    final canTapResend = !resendGestureDisabled;

    final Color resendCodeColor;
    if (isOnCooldown) {
      resendCodeColor = mutedResendAndIn;
    } else if (canTapResend) {
      resendCodeColor = timerAndActiveResend;
    } else {
      resendCodeColor = mutedResendAndIn;
    }

    final leadingStyle = AppTextStyles.caption(context).copyWith(
      color: resendGestureDisabled
          ? theme.disabledColor
          : (isDark ? AppColors.darkGreyText : AppColors.greyText),
      fontWeight: FontWeight.w400,
      height: 1.4,
    );

    final resendSemiBoldStyle = AppTextStyles.boldBody(context).copyWith(
      color: resendCodeColor,
      fontWeight: FontWeight.w600,
      height: 1.4,
    );

    final inRegularStyle = AppTextStyles.bodyText(context).copyWith(
      color: mutedResendAndIn,
      fontWeight: FontWeight.w400,
      height: 1.4,
    );

    final timerRegularStyle = AppTextStyles.bodyText(context).copyWith(
      color: timerAndActiveResend,
      fontWeight: FontWeight.w400,
      height: 1.4,
    );

    return GestureDetector(
      onTap: resendGestureDisabled ? null : onResend,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 0,
        children: [
          Text(
            '${l10n.didntReceiveCode} ',
            style: leadingStyle,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: Directionality.of(context),
            children: [
              Text(
                l10n.resendCode,
                style: resendSemiBoldStyle,
              ),
              if (isOnCooldown) ...[
                Text(' ${l10n.resendCodeIn} ', style: inRegularStyle),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    formatOtpResendCooldownTimer(cooldownRemaining),
                    style: timerRegularStyle,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
