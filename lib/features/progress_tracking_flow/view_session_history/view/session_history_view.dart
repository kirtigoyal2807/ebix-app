import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../widgets/app_app_bar.dart';
import '../cubit/session_history_cubit.dart';
import '../cubit/session_history_state.dart';
import '../widget/session_history_button.dart';
import '../widget/session_history_card.dart';

class SessionHistoryView extends StatelessWidget {
  const SessionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => SessionHistoryCubit(),
      child: Scaffold(
        appBar: AppAppBar(
          onBack: () => Navigator.of(context).pop(),
          title: context.l10n.session_history_title,
          isMoreMenu: false,
        ),
        body: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SessionHistoryButton(),

              SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: _totalCard(
                      label: context.l10n.session_history_classes,
                      value: "42",
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _totalCard(
                      label: context.l10n.session_history_total_time,
                      value: "31h",
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _totalCard(
                      label: context.l10n.session_history_points,
                      value: "1050",
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              BlocBuilder<SessionHistoryCubit, SessionHistoryState>(
                builder: (context, state) {
                  return AppText(
                    state.selectedSessionHistory == SessionHistory.allTime
                        ? context.l10n.session_history_all_time
                        : state.selectedSessionHistory ==
                              SessionHistory.thisMonth
                        ? context.l10n.session_history_this_month
                        : context.l10n.session_history_last_30_days,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  );
                },
              ),
              SizedBox(height: AppSpacing.base),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 6,

                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SessionHistoryCard();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _totalCard({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          AppText(
            value,
            style: (context) => AppTextStyles.bottomSheetTitle(
              context,
            ).copyWith(fontWeight: FontWeight.w600, height: 1.55),
          ),
          SizedBox(height: AppSpacing.xs),
          AppText(
            label,
            style: (context) =>
                AppTextStyles.caption(context).copyWith(height: 1.55),
          ),
        ],
      ),
    );
  }
}
