import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../account/account_view.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'widgets/home_header.dart';
import 'widgets/spring_challenge_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/membership_card.dart';
import 'widgets/progress_card.dart';
import 'widgets/featured_class_card.dart';
import 'widgets/horizontal_list_section.dart';

import '../booking/booking_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Scaffold(
            backgroundColor: isDark
                ? AppColors.homeBackground
                : AppColors.whiteColor,
            body: IndexedStack(
              index: state.currentIndex,
              children: [
                const HomeContentView(),
                const BookingView(),
                const Center(child: Text('Explore')),
                const AccountView()
              ],
            ),
            bottomNavigationBar: _buildBottomNavBar(
              context,
              state.currentIndex,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppColors.splashBackgroundDark;
    final inactiveColor = isDark ? Colors.grey : Colors.grey.shade400;

    return Container(
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => context.read<HomeCubit>().setTab(index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
        selectedLabelStyle: TextStyle(
          fontSize: size.width * 0.03 > 12 ? 12 : size.width * 0.03,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: size.width * 0.03 > 12 ? 12 : size.width * 0.03,
        ),
        iconSize: size.width * 0.06 > 24 ? 24 : size.width * 0.06,
        items: [
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: context.l10n.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1
                  ? Icons.fitness_center
                  : Icons.fitness_center_outlined,
            ),
            label: context.l10n.classesNav,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2 ? Icons.explore : Icons.explore_outlined,
            ),
            label: context.l10n.explore,
          ),
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 3 ? Icons.person : Icons.person_outline),
            label: context.l10n.account,
          ),
        ],
      ),
    );
  }
}

class HomeContentView extends StatelessWidget {
  const HomeContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(userName: state.userName),
                    const SizedBox(height: AppSpacing.md),

                    const SpringChallengeCard(),
                    const SizedBox(height: AppSpacing.lg),
                    const QuickActions(),
                    const SizedBox(height: AppSpacing.lg),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: AppText(
                        context.l10n.yourMembership,
                        style: (context) =>
                            AppTextStyles.heading1(context).copyWith(
                              color: isDark
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                              fontSize: size.width * 0.055 > 18
                                  ? 18
                                  : size.width * 0.055,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    MembershipCard(status: HomeUserStatus.empty),
                    const SizedBox(height: AppSpacing.md),
                    MembershipCard(status: HomeUserStatus.expired),
                    const SizedBox(height: AppSpacing.md),
                    MembershipCard(status: HomeUserStatus.existing),

                    const SizedBox(height: AppSpacing.lmd),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: AppText(
                        context.l10n.yourProgress,
                        style: (context) =>
                            AppTextStyles.heading1(context).copyWith(
                              color: isDark
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                              fontSize: size.width * 0.055 > 18
                                  ? 18
                                  : size.width * 0.055,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProgressCard(
                      status: HomeUserStatus.empty,
                      classesDone: state.classesDone,
                      totalHours: state.totalHours,
                      goalClasses: state.goalClasses,
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AppText(
                              context.l10n.yourProgress,
                              style: (context) =>
                                  AppTextStyles.heading1(context).copyWith(
                                    color: isDark
                                        ? AppColors.lightText
                                        : AppColors.darkText,
                                    fontSize: size.width * 0.055 > 18
                                        ? 18
                                        : size.width * 0.055,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                          AppText(
                            context.l10n.seeAll,
                            style: (context) =>
                                AppTextStyles.captionText(context).copyWith(
                                  color: isDark
                                      ? AppColors.languageTextDark
                                      : AppColors.languageIcon,
                                  fontSize: size.width * 0.03 > 14
                                      ? 14
                                      : size.width * 0.03,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProgressCard(
                      status: HomeUserStatus.existing,
                      classesDone: state.classesDone,
                      totalHours: state.totalHours,
                      goalClasses: state.goalClasses,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    MembershipCard(status: state.status),
                    const SizedBox(height: AppSpacing.md),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: AppText(
                        context.l10n.featuredClass,
                        style: (context) =>
                            AppTextStyles.heading1(context).copyWith(
                              color: isDark
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                              fontSize: size.width * 0.055 > 18
                                  ? 18
                                  : size.width * 0.055,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const FeaturedClassCard(),
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AppText(
                              context.l10n.classTypes,
                              style: (context) =>
                                  AppTextStyles.heading1(context).copyWith(
                                    color: isDark
                                        ? AppColors.lightText
                                        : AppColors.darkText,
                                    fontSize: size.width * 0.055 > 18
                                        ? 18
                                        : size.width * 0.055,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                          AppText(
                            context.l10n.seeAll,
                            style: (context) =>
                                AppTextStyles.captionText(context).copyWith(
                                  color: isDark
                                      ? AppColors.languageTextDark
                                      : AppColors.languageIcon,
                                  fontSize: size.width * 0.03 > 14
                                      ? 14
                                      : size.width * 0.03,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const ClassTypesSection(),
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AppText(
                              context.l10n.topTrainers,
                              style: (context) =>
                                  AppTextStyles.heading1(context).copyWith(
                                    color: isDark
                                        ? AppColors.lightText
                                        : AppColors.darkText,
                                    fontSize: size.width * 0.055 > 18
                                        ? 18
                                        : size.width * 0.055,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                          AppText(
                            context.l10n.seeAll,
                            style: (context) =>
                                AppTextStyles.captionText(context).copyWith(
                                  color: isDark
                                      ? AppColors.languageTextDark
                                      : AppColors.languageIcon,
                                  fontSize: size.width * 0.03 > 14
                                      ? 14
                                      : size.width * 0.03,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const TopTrainersSection(),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
