import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/explore/view/redeem_card_view.dart';
import 'package:pilates_app/features/explore/widget/receive_gift_sheet.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../account/account_view.dart';
import '../auth/cubit/auth_cubit.dart';
import '../auth/cubit/auth_flow.dart';
import '../auth/cubit/auth_state.dart';
import '../auth/data/models/auth_user.dart';
import '../explore/explore_view.dart';
import '../explore/view/referral_program_view.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'data/models/home_response.dart';
import 'data/home_repository.dart';
import 'widgets/home_header.dart';
import 'widgets/spring_challenge_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/membership_card.dart';
import 'widgets/progress_card.dart';
import 'widgets/featured_class_card.dart';
import 'widgets/horizontal_list_section.dart';
import 'widgets/received_gift_card.dart';
import 'home_tab_intent.dart';

import '../booking/cubit/booking_state.dart';
import '../booking/booking_view.dart';
import 'booking_flow_navigation.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    this.initialNavIndex = 0,
    this.initialBookingTab = BookingTab.classes,
  });

  /// Bottom navigation index (1 = Classes / booking tab).
  final int initialNavIndex;

  /// Sub-tab when [initialNavIndex] is the booking tab.
  final BookingTab initialBookingTab;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        homeRepository: HomeRepository(
          context.read<AuthCubit>().authRepository.httpClient,
        ),
        tokenStorage: context.read<AuthCubit>().tokenStorage,
        initialState: HomeState.initial().copyWith(
          currentIndex: initialNavIndex,
          selectedBookingTab: initialBookingTab,
        ),
      )..loadHome(),
      child: _HomeBookingFlowTabListener(
        child: const _HomeTabIntentListener(child: _HomeShell()),
      ),
    );
  }
}

class _HomeTabIntentListener extends StatefulWidget {
  const _HomeTabIntentListener({required this.child});

  final Widget child;

  @override
  State<_HomeTabIntentListener> createState() => _HomeTabIntentListenerState();
}

class _HomeTabIntentListenerState extends State<_HomeTabIntentListener> {
  void _onIntent() {
    final tab = homeTabIntent.value;
    if (tab == null || !mounted) return;
    context.read<HomeCubit>().setTab(tab);
    homeTabIntent.value = null;
  }

  @override
  void initState() {
    super.initState();
    homeTabIntent.addListener(_onIntent);
  }

  @override
  void dispose() {
    homeTabIntent.removeListener(_onIntent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _HomeShell extends StatelessWidget {
  const _HomeShell();

  @override
  Widget build(BuildContext context) {
    return _PendingGiftPopupTrigger(
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
                BookingView(initialTab: state.selectedBookingTab),
                const ExploreView(),
                const AccountView(),
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
    // Use viewPadding (not padding) so we still detect devices with system
    // gesture / nav insets even when an ancestor SafeArea has consumed the
    // padding. On devices with no system inset (e.g. older phones with
    // hardware buttons) add a small bottom gap for visual comfort.
    final bottomSafeArea = MediaQuery.viewPaddingOf(context).bottom;
    final bottomPadding = bottomSafeArea > 0 ? 0.0 : AppSpacing.base;
    final activeColor = isDark
        ? AppColors.languageIconDark
        : AppColors.languageIcon;
    final inactiveColor = isDark ? AppColors.lightGrey : AppColors.lightGrey;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
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
        onTap: (index) {
          final homeCubit = context.read<HomeCubit>();
          final previousIndex = homeCubit.state.currentIndex;
          homeCubit.setTab(index);
          // Refresh profile when switching to home tab (0) or account tab (3)
          if ((index == 0 && previousIndex != 0) ||
              (index == 3 && previousIndex != 3)) {
            context.read<AuthCubit>().refreshProfileWhenSelectingAccountTab();
          }
        },
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
            icon: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 3,
              ),
              child: SvgPicture.asset(
                "assets/images/svg/ic_home.svg",
                color: currentIndex == 0
                    ? (isDark
                          ? AppColors.languageIconDark
                          : AppColors.languageIcon)
                    : AppColors.darkGreyText,
                height: 18,
                width: 16,
              ),
            ),
            label: context.l10n.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1
                  ? Icons.self_improvement
                  : Icons.self_improvement,
              color: currentIndex == 1
                  ? (isDark
                        ? AppColors.languageIconDark
                        : AppColors.languageIcon)
                  : AppColors.darkGreyText,
            ),
            label: context.l10n.classesNav,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2
                  ? Icons.manage_search
                  : Icons.manage_search_outlined,
              color: currentIndex == 2
                  ? (isDark
                        ? AppColors.languageIconDark
                        : AppColors.languageIcon)
                  : AppColors.darkGreyText,
            ),
            label: context.l10n.explore,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3 ? Icons.person : Icons.person_outline,
              color: currentIndex == 3
                  ? (isDark
                        ? AppColors.languageIconDark
                        : AppColors.languageIcon)
                  : AppColors.darkGreyText,
            ),
            label: context.l10n.account,
          ),
        ],
      ),
    );
  }
}

/// Opens `RedeemCardView` directly when profile `pendingGift` is available.
/// No local tracking; shows every time.
/// Also refreshes home and profile when language changes.
class _PendingGiftPopupTrigger extends StatefulWidget {
  const _PendingGiftPopupTrigger({required this.child});

  final Widget child;

  @override
  State<_PendingGiftPopupTrigger> createState() =>
      _PendingGiftPopupTriggerState();
}

class _PendingGiftPopupTriggerState extends State<_PendingGiftPopupTrigger> {
  String? _lastLocaleCode;

  @override
  void initState() {
    super.initState();
    _lastLocaleCode = context.read<AuthCubit>().state.locale.languageCode;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<AuthCubit>().loadProfile();
      if (!mounted) return;
      _maybeShow(context.read<AuthCubit>().state);
    });
  }

  void _maybeShow(AuthState state) {
    if (!mounted) return;
    if (state.flow != AuthFlow.authenticated) return;
    final homeIndex = context.read<HomeCubit>().state.currentIndex;
    if (homeIndex != 0) return;
    final gift = state.user?.pendingGift;
    if (gift == null) return;
    if (gift.canBeRedeemed != true) return;
    final id = gift.id;
    if (id == null || id.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.bottomSheetShadow,
      builder: (_) => ReceiveGiftSheet(
        pendingGift: gift,
        onViewGift: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RedeemCardView(
                pendingGift: gift,
                onRedeemed: () {
                  context
                      .read<AuthCubit>()
                      .refreshProfileWhenSelectingAccountTab();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _onLocaleChanged() {
    // Refresh home and profile when language changes (with loading indicator)
    context.read<HomeCubit>().refreshHomeWithLoading();
    context.read<AuthCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        // Listen for pending gift changes OR locale changes
        if (previous.user?.pendingGift?.id != current.user?.pendingGift?.id) {
          return true;
        }
        if (previous.locale.languageCode != current.locale.languageCode) {
          return true;
        }
        return false;
      },
      listener: (_, state) {
        final currentLocaleCode = state.locale.languageCode;
        if (_lastLocaleCode != null && _lastLocaleCode != currentLocaleCode) {
          _onLocaleChanged();
        }
        _lastLocaleCode = currentLocaleCode;
        _maybeShow(state);
      },
      child: widget.child,
    );
  }
}

/// Listens for [openClassesBookingTabAfterPopToRoot] after user leaves booking
/// success / waitlist success and pops the flow to root.
class _HomeBookingFlowTabListener extends StatefulWidget {
  const _HomeBookingFlowTabListener({required this.child});

  final Widget child;

  @override
  State<_HomeBookingFlowTabListener> createState() =>
      _HomeBookingFlowTabListenerState();
}

class _HomeBookingFlowTabListenerState
    extends State<_HomeBookingFlowTabListener> {
  @override
  void initState() {
    super.initState();
    openClassesBookingTabAfterPopToRoot.addListener(_onOpenClassesRequest);
  }

  @override
  void dispose() {
    openClassesBookingTabAfterPopToRoot.removeListener(_onOpenClassesRequest);
    super.dispose();
  }

  void _onOpenClassesRequest() {
    if (!openClassesBookingTabAfterPopToRoot.value || !mounted) return;
    openClassesBookingTabAfterPopToRoot.value = false;
    context.read<HomeCubit>().setTab(1, bookingTab: BookingTab.classes);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// True when home or profile exposes a plan name or session fields (see [MembershipSnapshot.hasAnyMembershipHint]).
bool _userHasMembershipPlan(HomeMembership? membership, AuthUser? user) {
  final mPlan = membership?.planName?.trim() ?? '';
  if (mPlan.isNotEmpty) return true;
  if (membership?.totalSessions != null ||
      membership?.sessionsRemaining != null) {
    return true;
  }
  final uPlan = user?.membershipPlanName?.trim() ?? '';
  if (uPlan.isNotEmpty) return true;
  if (user?.membershipTotalSessions != null ||
      user?.membershipSessionsRemaining != null) {
    return true;
  }
  return false;
}

class HomeContentView extends StatelessWidget {
  const HomeContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.loadStatus == HomeLoadStatus.initial ||
            state.loadStatus == HomeLoadStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.loadStatus == HomeLoadStatus.failure && state.data == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  state.errorMessage.isNotEmpty
                      ? state.errorMessage
                      : context.l10n.loginErrorGeneric,
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () => context.read<HomeCubit>().loadHome(),
                  child: AppText(
                    context.l10n.retry,
                    style: AppTextStyles.button,
                  ),
                ),
              ],
            ),
          );
        }
        final data = state.data;
        if (data == null) {
          return const SizedBox.shrink();
        }
        final banners = data.banners;
        final membership = data.membership;
        final progress = data.progress;
        final featuredClasses = data.featuredClasses;
        final featuredClass = featuredClasses.isEmpty
            ? null
            : featuredClasses.first;
        final classTypes = data.classTypes;
        final topTrainers = data.topTrainers;
        final receivedGifts = data.receivedGifts;

        final attendedClasses = progress?.mtdAttendedClasses ?? 0;
        final attendedMinutes = progress?.mtdAttendedMinutes ?? 0;
        final monthlyTarget = progress?.monthlyTargetClasses ?? 0;
        final goalClasses = monthlyTarget <= 0 ? 1 : monthlyTarget;
        final totalHours = attendedMinutes / 60;
        // Show the active progress card whenever the API returns a progress
        // object — even if the user hasn't attended any classes yet this month.
        // Only fall back to the empty/onboarding card when there is no
        // progress object at all (i.e. the user has never had a membership).
        final progressStatus =
            (progress != null && progress.monthlyTargetClasses > 0)
            ? HomeUserStatus.existing
            : HomeUserStatus.empty;

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.wait<void>([
                    context.read<HomeCubit>().refreshHome(),
                    context.read<AuthCubit>().loadProfile(),
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          final fromProfile =
                              authState.user?.greetingName ?? '';
                          final displayName = fromProfile.isNotEmpty
                              ? fromProfile
                              : '';
                          return HomeHeader(userName: displayName);
                        },
                      ),
                      SizedBox(height: AppSpacing.lg),
                      if (banners.isNotEmpty) ...[
                        SpringChallengeCard(
                          banners: banners,
                          onBannerTap: (banner) =>
                              _handleBannerTap(context, banner),
                        ),
                        SizedBox(height: AppSpacing.lg),
                      ],
                      const QuickActions(),
                      if (receivedGifts.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.lg),
                        _sectionTitle(
                          context,
                          context.l10n.giftReceivedTitle,
                          isDark,
                          size,
                        ),
                        SizedBox(height: AppSpacing.md),
                        ReceivedGiftCard(gift: receivedGifts.first),
                      ],
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          final user = authState.user;
                          final hasPlan = _userHasMembershipPlan(
                            membership,
                            user,
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: AppSpacing.lg),
                              _sectionTitle(
                                context,
                                context.l10n.yourMembership,
                                isDark,
                                size,
                              ),
                              SizedBox(height: AppSpacing.md),
                              MembershipCard(
                                status: hasPlan
                                    ? HomeUserStatus.existing
                                    : HomeUserStatus.empty,
                                planName:
                                    membership?.planName ??
                                    user?.membershipPlanName,
                                totalSessions:
                                    membership?.totalSessions ??
                                    user?.membershipTotalSessions,
                                sessionsRemaining:
                                    membership?.sessionsRemaining ??
                                    user?.membershipSessionsRemaining,
                              ),
                            ],
                          );
                        },
                      ),
                      if (progress != null) ...[
                        SizedBox(height: AppSpacing.lg),
                        _sectionTitle(
                          context,
                          context.l10n.yourProgress,
                          isDark,
                          size,
                        ),
                        SizedBox(height: AppSpacing.md),
                        ProgressCard(
                          status: progressStatus,
                          classesDone: attendedClasses,
                          totalHours: totalHours,
                          goalClasses: goalClasses,
                          goalPercent: progress.goalPercent,
                        ),
                      ],
                      if (featuredClass != null) ...[
                        SizedBox(height: AppSpacing.lg),
                        _sectionTitle(
                          context,
                          context.l10n.featuredClass,
                          isDark,
                          size,
                        ),
                        SizedBox(height: AppSpacing.md),
                        FeaturedClassCard(featuredClass: featuredClass),
                      ],
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          final hasPlan = _userHasMembershipPlan(
                            membership,
                            authState.user,
                          );
                          if (!hasPlan) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (classTypes.isNotEmpty) ...[
                                SizedBox(height: AppSpacing.lg),
                                _sectionTitleWithSeeAll(
                                  context,
                                  context.l10n.classTypes,
                                  isDark,
                                  size,
                                  onTap: () =>
                                      context.read<HomeCubit>().setTab(1),
                                ),
                                SizedBox(height: AppSpacing.md),
                                ClassTypesSection(classTypes: classTypes),
                              ],
                              if (topTrainers.isNotEmpty) ...[
                                SizedBox(height: AppSpacing.lg),
                                _sectionTitleWithSeeAll(
                                  context,
                                  context.l10n.topTrainers,
                                  isDark,
                                  size,
                                  onTap: () => context.read<HomeCubit>().setTab(
                                    1,
                                    bookingTab: BookingTab.trainers,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.md),
                                TopTrainersSection(trainers: topTrainers),
                              ],
                            ],
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.lg),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionTitle(
    BuildContext context,
    String title,
    bool isDark,
    Size size,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: AppText(
        title,
        style: (context) => AppTextStyles.heading1(context).copyWith(
          color: isDark ? AppColors.lightText : AppColors.darkText,
          fontSize: size.width * 0.055 > 18 ? 18 : size.width * 0.055,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _sectionTitleWithSeeAll(
    BuildContext context,
    String title,
    bool isDark,
    Size size, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AppText(
              title,
              style: (context) => AppTextStyles.heading1(context).copyWith(
                color: isDark ? AppColors.lightText : AppColors.darkText,
                fontSize: size.width * 0.055 > 18 ? 18 : size.width * 0.055,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: AppText(
              context.l10n.seeAll,
              style: (context) =>
                  AppTextStyles.captionText(
                    context,
                    fontWeight: FontWeight.w500,
                  ).copyWith(
                    color: isDark
                        ? AppColors.languageTextDark
                        : AppColors.languageIcon,
                    fontSize: 14,
                    height: 1.2,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleBannerTap(BuildContext context, HomeBanner banner) async {
    final actionType = (banner.actionType ?? '').trim().toLowerCase();
    if (actionType.isEmpty) return;

    final authState = context.read<AuthCubit>().state;
    final userId = authState.user?.id ?? '';
    final payload = banner.actionPayload ?? const <String, dynamic>{};

    if (actionType == 'screen') {
      _handleBannerScreenAction(context, payload);
      return;
    }

    String? rawTarget;
    if (actionType == 'deeplink') {
      rawTarget = payload['url']?.toString();
    } else if (actionType == 'externalurl') {
      rawTarget =
          payload['externalUrl']?.toString() ?? payload['url']?.toString();
    } else {
      return;
    }

    if ((rawTarget ?? '').trim().isEmpty) {
      return;
    }

    final resolved = rawTarget!.replaceAll('{userId}', userId);
    final uri = Uri.tryParse(resolved);
    if (uri == null) {
      return;
    }

    final mode = actionType == 'externalurl'
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault;
    await launchUrl(uri, mode: mode);
  }

  void _handleBannerScreenAction(
    BuildContext context,
    Map<String, dynamic> payload,
  ) {
    final screen = (payload['screen']?.toString() ?? '').trim().toLowerCase();
    if (screen.isEmpty) {
      return;
    }

    switch (screen) {
      case 'classes':
      case 'classcategories':
        context.read<HomeCubit>().setTab(1, bookingTab: BookingTab.classes);
        break;
      case 'trainers':
        context.read<HomeCubit>().setTab(1, bookingTab: BookingTab.trainers);
        break;
      case 'referral':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReferralProgramView()),
        );
        break;
      default:
        break;
    }
  }
}
