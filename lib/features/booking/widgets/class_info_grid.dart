import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/booking/data/models/trainer_resource.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../views/trainer_details_view.dart';

class ClassInfoGrid extends StatelessWidget {
  const ClassInfoGrid({super.key, required this.slot});

  final ClassSlotViewModel slot;

  /// Determines if the user has an active membership.
  /// Checks AuthCubit and token storage (HomeCubit is not available in this context).
  bool _resolveHasMembership(BuildContext context) {
    final authPlanName =
        context.select((AuthCubit cubit) => cubit.state.user?.membershipPlanName) ??
        '';
    final storedPlanName =
        context.read<AuthCubit>().tokenStorage.readMembershipPlanName() ?? '';
    final resolvedPlanName = authPlanName.trim().isNotEmpty
        ? authPlanName.trim()
        : storedPlanName.trim();
    return resolvedPlanName.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final hasMembership = _resolveHasMembership(context);
    final hasSlot = slot.hasBookableSlot;
    final dateLabel = hasSlot
        ? _formatDateTime(slot.startAt)
        : context.l10n.noUpcomingClasses;
    final availability = !hasSlot
        ? context.l10n.noUpcomingClasses
        : slot.slotsLeft != null
        ? context.l10n.spotsLeft(slot.slotsLeft!)
        : "0";
    final durationLabel = slot.durationMinutes != null
        ? context.l10n.minutesCount(slot.durationMinutes!)
        : '--';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainerDetailsView(
                        trainer: TrainerResource(
                          id: slot.trainerId ?? '',
                          displayName: slot.trainerName,
                          specialties: const [],
                          certifications: const [],
                          branches: const [],
                          avatarUrl: slot.trainerImageUrl,
                        ),
                      ),
                    ),
                  );
                },
                child: _InfoCard(
                  label: context.l10n.instructor,
                  value: slot.trainerName.isNotEmpty
                      ? slot.trainerName
                      : context.l10n.trainerUnknown,
                  showAvatar: true,
                  imageUrl: slot.trainerImageUrl,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _InfoCard(
                label: context.l10n.duration,
                value: durationLabel,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            // Date & Time card: full width when no membership, otherwise half width
            Expanded(
              flex: hasMembership ? 1 : 2,
              child: _InfoCard(label: context.l10n.dateTime, value: dateLabel),
            ),
            // Only show availability card when user has membership
            if (hasMembership) ...[
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _InfoCard(
                  label: context.l10n.availability,
                  value: availability,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final slotDay = DateTime(dt.year, dt.month, dt.day);
    final timeStr = DateFormat('h:mm a').format(dt.toLocal());
    if (slotDay == today) return 'Today, $timeStr';
    final tomorrow = today.add(const Duration(days: 1));
    if (slotDay == tomorrow) return 'Tomorrow, $timeStr';
    return '${DateFormat('EEE, MMM d').format(dt.toLocal())}, $timeStr';
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final bool showAvatar;
  final String? imageUrl;

  const _InfoCard({
    required this.label,
    required this.value,
    this.showAvatar = false,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            label,
            style: (ctx) => AppTextStyles.captionText(
              ctx,
            ).copyWith(color: AppColors.lightGrey, fontSize: 12),
          ),
          SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              if (showAvatar) ...[
                CircleAvatar(
                  radius: 12,
                  backgroundImage: (imageUrl ?? '').trim().isNotEmpty
                      ? NetworkImage(imageUrl!)
                      : const AssetImage(
                              "assets/images/demo images/Trainer Avatar.png",
                            )
                            as ImageProvider,
                ),
                const SizedBox(width: 8),
              ] else ...[
                const SizedBox(height: 24),
              ],
              Expanded(
                child: AppText(
                  value,
                  style: (ctx) => AppTextStyles.boldBody(ctx).copyWith(
                    fontSize: 14,
                    color: showAvatar
                        ? (isDark
                              ? AppColors.languageTextDark
                              : AppColors.languageIcon)
                        : (isDark ? AppColors.lightText : AppColors.darkText),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
