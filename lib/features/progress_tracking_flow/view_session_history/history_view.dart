import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/progress_tracking_flow/view_session_history/cubit/session_history_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/view_session_history/cubit/session_history_state.dart';
import 'package:pilates_app/features/progress_tracking_flow/view_session_history/view/session_history_view.dart';
import 'package:pilates_app/features/progress_tracking_flow/view_session_history/widget/session_history_card.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../widgets/app_button.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.session_history_title,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  ),
                  SizedBox(height: AppSpacing.base),
                  BlocBuilder<SessionHistoryCubit, SessionHistoryState>(
                    builder: (context, state) {
                      if (state.isLoading && state.sessions.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state.sessions.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: AppText(
                            context.l10n.noClassesYet,
                            style: (context) => AppTextStyles.bodyText(context),
                          ),
                        );
                      }
                      final preview = state.sessions.take(4).toList();
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: preview.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          return SessionHistoryCard(item: preview[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.homeBackground : Colors.white,
          ),
          child: AppButton(
            label: context.l10n.session_history_view_full,
            onPressed: () {
              final cubit = context.read<SessionHistoryCubit>();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: const SessionHistoryView(),
                  ),
                ),
              );
            },
            variant: AppButtonVariant.primary,
          ),
        ),
      ],
    );
  }
}
