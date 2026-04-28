import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/core/constants/check_in_policy.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_spacing.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_app_bar.dart';
import '../cubit/push_notification_cubit.dart';
import '../cubit/push_notification_state.dart';
import '../widget/switch_widget.dart';

class PushNotificationView extends StatelessWidget {
  const PushNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => PushNotificationCubit(),
      child: Scaffold(
        appBar: AppAppBar(
          onBack: () => Navigator.of(context).pop(),
          title: l10n.pushNotifications,
          isMoreMenu: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: BlocBuilder<PushNotificationCubit, PushNotificationState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText(text: l10n.allNotifications),
                    SizedBox(height: AppSpacing.md),
                    SwitchWidget(
                      title: l10n.allNotifications,

                      switchValue: state.allNotification,
                      onChanged: (bool p1) {
                        context
                            .read<PushNotificationCubit>()
                            .changeAllNotification(p1);
                      },
                    ),
                    SizedBox(height: AppSpacing.xl),
                    titleText(text: l10n.classNotifications),
                    SizedBox(height: AppSpacing.md),
                    SwitchWidget(
                      title: l10n.beforeClassStarts,
                      subTitle: l10n.beforeClassStartsSubtitle(
                        CheckInPolicy.kOpensBeforeStart.inMinutes,
                      ),

                      switchValue: state.beforeClassStart,
                      onChanged: (bool p1) {
                        context
                            .read<PushNotificationCubit>()
                            .changeBeforeClassStart(p1);
                      },
                    ),

                    SizedBox(height: AppSpacing.md),
                    Divider(
                      height: 1,
                      color: isDark ? AppColors.greyText : AppColors.divider,
                    ),
                    SizedBox(height: AppSpacing.md),
                    SwitchWidget(
                      title: l10n.dayBeforeReminder,
                      subTitle: l10n.dayBeforeReminderSubtitle,

                      switchValue: state.dayBeforeRemainder,
                      onChanged: (bool p1) {
                        context
                            .read<PushNotificationCubit>()
                            .changeDayBeforeRemainder(p1);
                      },
                    ),

                    SizedBox(height: AppSpacing.xxxl),

                    titleText(text: l10n.subscriptionBilling),
                    SizedBox(height: AppSpacing.md),
                    SwitchWidget(
                      title: l10n.paymentConfirmations,
                      subTitle: l10n.paymentConfirmationsSubtitle,

                      switchValue: state.paymentConfirmation,
                      onChanged: (bool p1) {
                        context
                            .read<PushNotificationCubit>()
                            .changePaymentConfirmation(p1);
                      },
                    ),

                    SizedBox(height: AppSpacing.md),
                    Divider(
                      height: 1,
                      color: isDark ? AppColors.greyText : AppColors.divider,
                    ),
                    SizedBox(height: AppSpacing.md),

                    SwitchWidget(
                      title: l10n.renewalReminders,
                      subTitle: l10n.renewalRemindersSubtitle,

                      switchValue: state.renewalRemainder,
                      onChanged: (bool p1) {
                        context
                            .read<PushNotificationCubit>()
                            .changeRenewalRemainder(p1);
                      },
                    ),

                    SizedBox(height: AppSpacing.xxxl),

                    titleText(text: l10n.marketingUpdates),
                    SizedBox(height: AppSpacing.md),
                    SwitchWidget(
                      title: l10n.promotionsOffers,
                      subTitle: l10n.promotionsOffersSubtitle,

                      switchValue: state.promotionOffer,
                      onChanged: (bool p1) {
                        context
                            .read<PushNotificationCubit>()
                            .changePromotionOffer(p1);
                      },
                    ),

                    SizedBox(height: AppSpacing.md),
                    Divider(
                      height: 1,
                      color: isDark ? AppColors.greyText : AppColors.divider,
                    ),
                    SizedBox(height: AppSpacing.md),

                    SwitchWidget(
                      title: l10n.appUpdates,
                      subTitle: l10n.appUpdatesSubtitle,

                      switchValue: state.appUpdate,
                      onChanged: (bool p1) {
                        context.read<PushNotificationCubit>().changeAppUpdate(
                          p1,
                        );
                      },
                    ),

                    SizedBox(height: AppSpacing.xxxl),

                    titleText(text: l10n.challengesRewards),
                    SizedBox(height: AppSpacing.md),
                    SwitchWidget(
                      title: l10n.newChallenges,
                      subTitle: l10n.newChallengesSubtitle,

                      switchValue: state.newChallenges,
                      onChanged: (bool p1) {
                        context
                            .read<PushNotificationCubit>()
                            .changeNewChallenges(p1);
                      },
                    ),
                    SizedBox(height: AppSpacing.md),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget titleText({required String text}) {
    return AppText(
      text,
      style: (context) => AppTextStyles.bodyText(
        context,
      ).copyWith(fontSize: 12, color: AppColors.lightGrey, height: 1.55),
    );
  }
}
