import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 6,
                    physics: NeverScrollableScrollPhysics(),

                    itemBuilder: (context, index) {
                      return SessionHistoryCard();
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SessionHistoryView()),
              );
            },
            variant: AppButtonVariant.primary,
          ),
        ),
      ],
    );
  }
}
