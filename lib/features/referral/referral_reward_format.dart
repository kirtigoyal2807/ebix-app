import 'package:pilates_app/core/localization/arb/app_localizations.dart';

import 'data/models/referral_program_details.dart';

String referralRewardDisplay(AppLocalizations l10n, ReferralReward reward) {
  final type = reward.type.trim();
  final value = reward.value;
  switch (type) {
    case 'points':
      if (value == null) {
        return '';
      }
      return l10n.points(value is int ? value : value.round());
    case 'discount_percent':
      if (value == null) {
        return '';
      }
      return l10n.referralRewardDiscountPercent(_formatNum(value));
    case 'discount_amount':
      if (value == null) {
        return '';
      }
      return l10n.referralRewardDiscountAmount(_formatNum(value));
    case 'free_session':
      return l10n.referralRewardFreeSession;
    default:
      if (type.isEmpty && value == null) {
        return '';
      }
      final label = [
        if (type.isNotEmpty) type,
        if (value != null) _formatNum(value),
      ].join(' ');
      return label.isEmpty ? '' : l10n.referralRewardFallback(label);
  }
}

String _formatNum(num n) {
  if (n == n.roundToDouble()) {
    return n.round().toString();
  }
  return n.toString();
}
