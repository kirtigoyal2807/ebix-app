import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../cubit/badge_cubit.dart';
import '../cubit/badge_state.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  static String _formatTypeLabel(String raw) {
    if (raw.trim().isEmpty) return raw;
    return raw
        .split(RegExp(r'[_\s]+'))
        .where((s) => s.isNotEmpty)
        .map(
          (s) =>
              '${s[0].toUpperCase()}${s.length > 1 ? s.substring(1).toLowerCase() : ''}',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<BadgeCubit, BadgeState>(
      buildWhen: (p, c) =>
          p.badges != c.badges || p.selectedBadgeTypeKey != c.selectedBadgeTypeKey,
      builder: (context, state) {
        final types = state.distinctBadgeTypes;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _filterChip(
              context: context,
              label: context.l10n.all,
              selected: state.selectedBadgeTypeKey == null,
              isDark: isDark,
              onTap: () =>
                  context.read<BadgeCubit>().setBadgeTypeFilter(null),
            ),
            for (final t in types)
              _filterChip(
                context: context,
                label: _formatTypeLabel(t),
                selected:
                    state.selectedBadgeTypeKey?.toLowerCase() == t.toLowerCase(),
                isDark: isDark,
                onTap: () =>
                    context.read<BadgeCubit>().setBadgeTypeFilter(t),
              ),
          ],
        );
      },
    );
  }

  Widget _filterChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : isDark
                  ? AppColors.primaryDarkButton
                  : AppColors.greyContainerBg,
          borderRadius: BorderRadius.circular(AppRadius.base),
        ),
        child: AppText(
          label,
          style: (context) =>
              AppTextStyles.textFieldHeading(context).copyWith(
                color: selected || isDark ? Colors.white : AppColors.darkText,
              ),
        ),
      ),
    );
  }
}
