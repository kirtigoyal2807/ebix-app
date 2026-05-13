import 'package:flutter/material.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_badge.dart';
import 'package:share_plus/share_plus.dart';

String buildBadgeShareMessage({
  required AppLocalizations l10n,
  required LoyaltyBadge badge,
  required String? formattedEarnedDate,
}) {
  final title =
      badge.name.trim().isNotEmpty ? badge.name.trim() : badge.badgeKey.trim();
  final buffer = StringBuffer()..writeln(title);

  if (badge.isEarned &&
      formattedEarnedDate != null &&
      formattedEarnedDate.isNotEmpty) {
    buffer.writeln(l10n.badge_earned_on(formattedEarnedDate));
  } else {
    buffer.writeln(l10n.badge_share_locked_status);
  }

  final desc = badge.description?.trim();
  if (desc != null && desc.isNotEmpty) {
    buffer.writeln();
    buffer.writeln(desc);
  }

  buffer.writeln();
  buffer.writeln(l10n.badge_share_footer(l10n.splashAppName));
  return buffer.toString().trimRight();
}

String badgeShareSubject(LoyaltyBadge badge) {
  final title =
      badge.name.trim().isNotEmpty ? badge.name.trim() : badge.badgeKey.trim();
  return title;
}

Rect? _shareRectFor(BuildContext context) {
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}

/// Opens the platform share sheet for [badge].
///
/// Returns `true` when sharing completes without throwing. On failure,
/// shows [AppLocalizations.somethingWentWrong] and returns `false`.
Future<bool> shareLoyaltyBadge({
  required BuildContext context,
  required LoyaltyBadge badge,
  required String? formattedEarnedDate,
}) async {
  final l10n = AppLocalizations.of(context);
  final text = buildBadgeShareMessage(
    l10n: l10n,
    badge: badge,
    formattedEarnedDate: formattedEarnedDate,
  );
  final subject = badgeShareSubject(badge);

  try {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject.isEmpty ? null : subject,
        sharePositionOrigin: _shareRectFor(context),
      ),
    );
    return true;
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(l10n.somethingWentWrong)),
      );
    }
    return false;
  }
}
