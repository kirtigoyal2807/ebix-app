import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/core/constants/check_in_policy.dart';
import 'package:pilates_app/core/notifications/notification_permission_service.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

import '../../../config/theme/app_spacing.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_app_bar.dart';
import '../cubit/push_notification_cubit.dart';
import '../cubit/push_notification_state.dart';
import '../data/notification_preferences_repository.dart';
import '../widget/switch_widget.dart';

class PushNotificationView extends StatelessWidget {
  const PushNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => PushNotificationCubit(
        repository: context.read<NotificationPreferencesRepository>(),
      )..loadPreferences(),
      child: Scaffold(
        appBar: AppAppBar(
          onBack: () => Navigator.of(context).pop(),
          title: l10n.pushNotifications,
          isMoreMenu: false,
        ),
        body: BlocBuilder<PushNotificationCubit, PushNotificationState>(
          builder: (context, state) {
            if (state.status == PushNotificationStatus.loading) {
              return const AppLoadingIndicator();
            }

            if (state.status == PushNotificationStatus.error &&
                state.preferences == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      state.errorMessage ?? l10n.somethingWentWrong,
                      style: (context) => AppTextStyles.bodyText(context),
                    ),
                    SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => context
                          .read<PushNotificationCubit>()
                          .loadPreferences(),
                      child: AppText(
                        l10n.retry,
                        style: (context) => AppTextStyles.bodyText(context),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleText(text: l10n.allNotifications),
                        SizedBox(height: AppSpacing.sm),
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
                        SizedBox(height: AppSpacing.sm),
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
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.divider,
                        ),
                        SizedBox(height: AppSpacing.sm),
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
                        SizedBox(height: AppSpacing.xl),
                        titleText(text: l10n.subscriptionBilling),
                        SizedBox(height: AppSpacing.sm),
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
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.divider,
                        ),
                        SizedBox(height: AppSpacing.sm),
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
                        SizedBox(height: AppSpacing.xl),
                        titleText(text: l10n.marketingUpdates),
                        SizedBox(height: AppSpacing.sm),
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
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.divider,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        SwitchWidget(
                          title: l10n.appUpdates,
                          subTitle: l10n.appUpdatesSubtitle,
                          switchValue: state.appUpdate,
                          onChanged: (bool p1) {
                            context
                                .read<PushNotificationCubit>()
                                .changeAppUpdate(p1);
                          },
                        ),
                        SizedBox(height: AppSpacing.xl),
                        titleText(text: l10n.challengesRewards),
                        SizedBox(height: AppSpacing.sm),
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
                        Divider(
                          height: 1,
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.divider,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  l10n.rewardsEarned,
                                  style: (context) =>
                                      AppTextStyles.textFieldHeading(
                                        context,
                                      ).copyWith(
                                        fontSize: 15,
                                        height: 1.60,
                                        color: isDark
                                            ? AppColors.lightText
                                            : AppColors.darkText,
                                      ),
                                ),

                                SizedBox(height: 2),

                                AppText(
                                  l10n.pointsAndAchievements,
                                  style: (context) =>
                                      AppTextStyles.bodyText(context).copyWith(
                                        color: AppColors.lightGrey,
                                        height: 1.60,
                                      ),
                                ),
                              ],
                            ),

                            Transform.scale(
                              alignment: Alignment.centerRight,
                              scale:
                                  0.8, // 👈 reduce overall size (try 0.7–0.9)
                              child: CupertinoSwitch(
                                value: state.rewardEarn,
                                onChanged: (bool p1) {
                                  context
                                      .read<PushNotificationCubit>()
                                      .changeRewardEarn(p1);
                                },

                                inactiveThumbColor: isDark
                                    ? AppColors.primary
                                    : AppColors.whiteColor,
                                inactiveTrackColor: isDark
                                    ? Color(0xff1C1917)
                                    : AppColors.seekBarLight,
                                activeTrackColor: isDark
                                    ? AppColors.primary
                                    : AppColors.primary,

                                thumbColor: isDark
                                    ? AppColors.lightText
                                    : AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
                if (state.status == PushNotificationStatus.updating)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const AppLoadingIndicator(),
                    ),
                  ),
              ],
            );
          },
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
