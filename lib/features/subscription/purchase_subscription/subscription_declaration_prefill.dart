import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/personal_information_profile_lock.dart';

/// Declaration / safety step defaults: profile display name first, then wizard
/// personal info ([SubscriptionState.name]), then values already on [SubscriptionState].
abstract final class SubscriptionDeclarationPrefill {
  SubscriptionDeclarationPrefill._();

  static String resolvedDeclarationName(
    SubscriptionState sub,
    AuthUser? user,
  ) {
    final fromProfile = PersonalInformationProfileLock.displayNameFromUser(user);
    if (fromProfile.isNotEmpty) return fromProfile;
    final fromWizard = sub.name.trim();
    if (fromWizard.isNotEmpty) return fromWizard;
    return sub.declarationName.trim();
  }

  static String resolvedDeclarationDate(
    SubscriptionState sub,
    String todayDdMmYyyy,
  ) {
    final d = sub.declarationDate.trim();
    if (d.isNotEmpty) return d;
    return todayDdMmYyyy;
  }

  /// Fills empty name / date from profile / wizard / cubit state and writes back
  /// to [SubscriptionCubit]. Signature is never prefilled. Returns whether any
  /// controller text changed.
  static bool applyIfControllersEmpty({
    required SubscriptionCubit cubit,
    required AuthUser? user,
    required TextEditingController nameController,
    required TextEditingController dateController,
  }) {
    final sub = cubit.state;
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var changed = false;

    final resolvedName = resolvedDeclarationName(sub, user);
    if (nameController.text.trim().isEmpty && resolvedName.isNotEmpty) {
      nameController.text = resolvedName;
      cubit.updateDeclarationName(resolvedName);
      changed = true;
    }

    if (dateController.text.trim().isEmpty) {
      final d = resolvedDeclarationDate(sub, today);
      dateController.text = d;
      cubit.updateDeclarationDate(d);
      changed = true;
    }

    return changed;
  }
}
