import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/progress_tracking_flow/view_session_history/cubit/session_history_cubit.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../cubit/session_history_state.dart';

class SessionHistoryButton extends StatelessWidget {
  const SessionHistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<SessionHistoryCubit, SessionHistoryState>(
      builder: (context, state) {
        return SizedBox(
          height: 28,
          child: ListView.separated(
            itemCount: state.sessionHistoryList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              bool isSelected =
                  state.selectedSessionHistory ==
                  state.sessionHistoryList[index];

              return GestureDetector(
                onTap: () {
                  context.read<SessionHistoryCubit>().setSelectedSessionHistory(
                    state.sessionHistoryList[index],
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.base,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected && isDark
                        ? AppColors.primary
                        : isSelected
                        ? AppColors.seekBarLight
                        : isDark
                        ? Colors.transparent
                        : AppColors.greyContainerBg,
                    borderRadius: BorderRadius.circular(AppRadius.base),
                  ),
                  child: AppText(
                    getCategoryLabel(context, state.sessionHistoryList[index]),
                    style: (context) =>
                        AppTextStyles.textFieldHeading(context).copyWith(
                          color: isDark
                              ? AppColors.lightText
                              : isSelected
                              ? AppColors.languageIcon
                              : AppColors.darkText,
                        ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String getCategoryLabel(BuildContext context, SessionHistory history) {
    switch (history) {
      case SessionHistory.allTime:
        return context.l10n.allTime;
      case SessionHistory.thisMonth:
        return context.l10n.session_history_this_month_txt;
      case SessionHistory.last30Days:
        return context.l10n.last30Days;
    }
  }
}
