import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/cubit/booking_cubit.dart';
import 'package:pilates_app/features/booking/cubit/booking_state.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/booking/data/models/gym_class_resource.dart';
import 'package:pilates_app/features/booking/data/models/trainer_certification.dart';
import 'package:pilates_app/features/booking/data/models/trainer_resource.dart';
import 'package:pilates_app/features/booking/data/trainers_repository.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../widgets/booking_class_card.dart';
import '../widgets/class_reviews_section.dart';
import '../widgets/tag_chip.dart';
import '../widgets/trainer_average_stars.dart';

typedef _TrainerDetailBundle = ({
  ApiResult<TrainerResource> trainer,
  ApiResult<List<GymClassResource>> classes,
});

List<ClassSlotViewModel> _trainerUpcomingSlots(
  TrainerResource trainer,
  List<GymClassResource> catalog,
) {
  final id = trainer.id.trim();
  final nameNorm = trainer.displayName.trim().toLowerCase();
  final now = DateTime.now();
  final out = <ClassSlotViewModel>[];
  for (final gc in catalog) {
    for (final ev in gc.upcomingEvents) {
      if (ev.startAt.isBefore(now)) continue;
      final tid = ev.trainerId?.trim();
      final matchesId = tid != null && tid.isNotEmpty && tid == id;
      final evName = ev.trainerName?.trim().toLowerCase() ?? '';
      final matchesName =
          (tid == null || tid.isEmpty) &&
          nameNorm.isNotEmpty &&
          evName == nameNorm;
      if (!matchesId && !matchesName) continue;
      out.add(ClassSlotViewModel.fromClassAndEvent(gc, ev));
    }
  }
  out.sort((a, b) => a.startAt.compareTo(b.startAt));
  return out;
}

void _openBrowseAllClasses(BuildContext context) {
  try {
    context.read<BookingCubit>().setTab(BookingTab.classes);
  } catch (_) {}
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

/// Trainer profile: pass [trainer] from §12.1 list for API-backed details (`GET /trainers/{id}`).
/// Omit [trainer] to keep the legacy marketing/demo layout (home shortcuts).
class TrainerDetailsView extends StatelessWidget {
  const TrainerDetailsView({super.key, this.trainer});

  final TrainerResource? trainer;

  @override
  Widget build(BuildContext context) {
    if (trainer != null) {
      return _TrainerDetailsApiRoute(summary: trainer!);
    }
    return const _TrainerDetailsDemoView();
  }
}

class _TrainerDetailsApiRoute extends StatefulWidget {
  const _TrainerDetailsApiRoute({required this.summary});

  final TrainerResource summary;

  @override
  State<_TrainerDetailsApiRoute> createState() =>
      _TrainerDetailsApiRouteState();
}

class _TrainerDetailsApiRouteState extends State<_TrainerDetailsApiRoute> {
  late Future<_TrainerDetailBundle> _bundleFuture;
  var _futureInitialized = false;

  /// Bumps to remount [ClassReviewsSection] so pull-to-refresh reloads `GET /reviews`.
  var _reviewsRefreshEpoch = 0;

  void _reloadBundle() {
    final trainers = context.read<TrainersRepository>();
    final classesRepo = context.read<ClassesRepository>();
    _bundleFuture = () async {
      final trainer = await trainers.getTrainer(widget.summary.id);
      final classes = await classesRepo.listClasses();
      return (trainer: trainer, classes: classes);
    }();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_futureInitialized) return;
    _futureInitialized = true;
    _reloadBundle();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_TrainerDetailBundle>(
      future: _bundleFuture,
      builder: (context, snapshot) {
        final bundle = snapshot.data;
        final data = bundle?.trainer;
        final TrainerResource effective =
            data != null && data.isSuccess && data.dataOrNull != null
            ? data.dataOrNull!
            : widget.summary;
        final err = data?.exceptionOrNull?.message;

        final classesRes = bundle?.classes;
        final catalog = classesRes != null && classesRes.isSuccess
            ? (classesRes.dataOrNull ?? const <GymClassResource>[])
            : const <GymClassResource>[];
        final slots = _trainerUpcomingSlots(effective, catalog);

        final embedded = effective.recentReviews;
        final useEmbeddedReviews = embedded != null && embedded.isNotEmpty;

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: AppAppBar(
            title: context.l10n.trainerDetails,
            isMoreMenu: false,
            onBack: () => Navigator.of(context).pop(),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  onPressed: () => _openBrowseAllClasses(context),
                  child: AppText(
                    context.l10n.browseAllClasses,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: (c) => AppTextStyles.boldBody(
                      c,
                    ).copyWith(color: AppColors.whiteColor, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _reviewsRefreshEpoch++;
                _reloadBundle();
              });
              await _bundleFuture;
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (err != null &&
                            err.isNotEmpty &&
                            data != null &&
                            data.isFailure)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: AppText(
                              err,
                              maxLines: 6,
                              style: (c) => AppTextStyles.bodyText(
                                c,
                              ).copyWith(color: AppColors.error),
                            ),
                          ),
                        _TrainerApiHeader(trainer: effective),
                        SizedBox(height: AppSpacing.md),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              if (effective.yearsExperience != null)
                                TagChip(
                                  label: context.l10n.yearsExperience(
                                    effective.yearsExperience!,
                                  ),
                                  fontSize: 14,
                                ),
                              for (final s in effective.specialties)
                                TagChip(label: s, fontSize: 14),
                            ],
                          ),
                        ),
                        _TrainerStatsRow(trainer: effective, isDark: isDark),
                        if (effective.bio != null &&
                            effective.bio!.trim().isNotEmpty) ...[
                          SizedBox(height: AppSpacing.lg),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: AppText(
                              '${context.l10n.about} ${effective.displayName}',
                              maxLines: 4,
                              style: (c) => AppTextStyles.gelasioRegular(c),
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: AppText(
                              effective.bio!,
                              maxLines: 200,
                              style: (c) => AppTextStyles.bodyText(
                                c,
                              ).copyWith(height: 1.55),
                            ),
                          ),
                        ],
                        if (effective.certifications.isNotEmpty) ...[
                          SizedBox(height: AppSpacing.lg),
                          _ApiCertificationsCard(
                            certifications: effective.certifications,
                          ),
                        ],
                        _TrainerTeachingStylesSection(
                          trainer: effective,
                          isDark: isDark,
                        ),
                        if (effective.branches.isNotEmpty) ...[
                          SizedBox(height: AppSpacing.md),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: AppText(
                              context.l10n.branch,
                              style: (c) => AppTextStyles.textFieldHeading(c),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: AppText(
                              effective.branches.map((b) => b.name).join(', '),
                              maxLines: 8,
                              style: (c) => AppTextStyles.bodyText(
                                c,
                              ).copyWith(height: 1.4),
                            ),
                          ),
                        ],
                        SizedBox(height: AppSpacing.xl),
                        ClassReviewsSection(
                          key: ValueKey(
                            'trainer_reviews_${effective.id}_$_reviewsRefreshEpoch',
                          ),
                          embeddedRecentReviews: useEmbeddedReviews
                              ? embedded
                              : null,
                          reviewableType: useEmbeddedReviews ? null : 'trainer',
                          reviewableId: useEmbeddedReviews
                              ? null
                              : effective.id,
                          summaryAvgRating: effective.avgRating,
                          summaryReviewsCount: effective.reviewsCount,
                          summaryRatingBreakdown: effective.ratingBreakdown,
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppText(
                                  context.l10n.upcomingClasses,
                                  maxLines: 2,
                                  style: (c) =>
                                      AppTextStyles.heading1(c).copyWith(
                                        color: isDark
                                            ? AppColors.lightText
                                            : AppColors.darkText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ),
                              InkWell(
                                onTap: () => _openBrowseAllClasses(context),
                                child: AppText(
                                  context.l10n.seeAll,
                                  maxLines: 1,
                                  style: (c) =>
                                      AppTextStyles.captionText(
                                        c,
                                        fontWeight: FontWeight.w500,
                                      ).copyWith(
                                        color: isDark
                                            ? AppColors.languageTextDark
                                            : AppColors.languageIcon,
                                        fontSize: 14,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.base),
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            bundle == null)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          )
                        else if (classesRes != null &&
                            classesRes.isFailure &&
                            slots.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: AppText(
                              (classesRes.exceptionOrNull?.message ?? '')
                                      .trim()
                                      .isEmpty
                                  ? context.l10n.noClassesFound
                                  : classesRes.exceptionOrNull!.message!,
                              maxLines: 3,
                              style: (c) => AppTextStyles.captionText(c),
                            ),
                          )
                        else if (slots.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: AppText(
                              context.l10n.noUpcomingClasses,
                              style: (c) => AppTextStyles.bodyText(
                                c,
                              ).copyWith(color: AppColors.lightGrey),
                            ),
                          )
                        else
                          for (final slot in slots.take(6)) ...[
                            BookingClassCard.fromSlot(slot),
                            const SizedBox(height: AppSpacing.md),
                          ],
                        SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TrainerStatsRow extends StatelessWidget {
  const _TrainerStatsRow({required this.trainer, required this.isDark});

  final TrainerResource trainer;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final entries = <({String value, String label})>[];
    final taught = trainer.totalClassesTaught;
    if (taught != null) {
      entries.add((value: '$taught', label: context.l10n.classesTaught));
    }
    final week = trainer.classesThisWeekCount;
    if (week != null) {
      entries.add((value: '$week', label: context.l10n.thisWeek));
    }
    final rr = trainer.returnRatePercent;
    if (rr != null) {
      entries.add((value: '$rr%', label: context.l10n.returnRate));
    }
    if (entries.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0) SizedBox(width: AppSpacing.md),
            Expanded(
              child: _TrainerDetailsDemoView._totalCard(
                value: entries[i].value,
                label: entries[i].label,
                isDark: isDark,
                context: context,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TrainerTeachingStylesSection extends StatelessWidget {
  const _TrainerTeachingStylesSection({
    required this.trainer,
    required this.isDark,
  });

  final TrainerResource trainer;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final styles = trainer.teachingStyles.isNotEmpty
        ? trainer.teachingStyles
        : [
            context.l10n.dynamicTxt,
            context.l10n.motivating,
            context.l10n.detailOriented,
            context.l10n.challenging,
            context.l10n.supporting,
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AppText(
            context.l10n.teachingStyle,
            style: (c) =>
                AppTextStyles.gelasioRegular(c).copyWith(height: 1.55),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Wrap(
            direction: Axis.horizontal,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final label in styles)
                _TrainerDetailsDemoView._teachingStyleCard(
                  label: label,
                  isDark: isDark,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrainerApiHeader extends StatelessWidget {
  const _TrainerApiHeader({required this.trainer});

  final TrainerResource trainer;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatar = trainer.avatarUrl;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          Center(
            child: ClipOval(
              child: avatar != null && avatar.isNotEmpty
                  ? Image.network(
                      avatar,
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/demo images/Trainer Avatar.png',
                        height: 90,
                        width: 90,
                      ),
                    )
                  : Image.asset(
                      'assets/images/demo images/Trainer Avatar.png',
                      height: 90,
                      width: 90,
                    ),
            ),
          ),
          SizedBox(height: AppSpacing.base),
          AppText(
            trainer.displayName,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: (c) => AppTextStyles.heading1(c).copyWith(height: 1.55),
          ),
          if (trainer.specialties.isNotEmpty) ...[
            SizedBox(height: AppSpacing.xs),
            AppText(
              trainer.specialties.first,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: (c) => AppTextStyles.bodyText(c).copyWith(height: 1.55),
            ),
          ],
          SizedBox(height: 10),
          _TrainerApiHeaderRating(trainer: trainer, isDark: isDark),
        ],
      ),
    );
  }
}

class _TrainerApiHeaderRating extends StatelessWidget {
  const _TrainerApiHeaderRating({required this.trainer, required this.isDark});

  final TrainerResource trainer;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final count = trainer.reviewsCount;
    final metaColor = isDark ? AppColors.darkGreyText : AppColors.lightGrey;
    final avgValue = trainer.averageRatingValue;
    final avgText = trainer.displayAverageRating;

    if (avgValue != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TrainerAverageStars(rating: avgValue, itemSize: 24),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                AppText(
                  avgText.isNotEmpty ? avgText : avgValue.toStringAsFixed(1),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: (c) => AppTextStyles.textFieldHeading(
                    c,
                    fontWeight: FontWeight.w600,
                  ).copyWith(height: 1, fontSize: 14),
                ),
                if (count > 0)
                  AppText(
                    '($count ${context.l10n.reviews})',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: (c) => AppTextStyles.helpAndSupportItemSubLabel(
                      c,
                    ).copyWith(height: 1.2, fontSize: 14),
                  ),
              ],
            ),
          ],
        ),
      );
    }

    if (avgText.isNotEmpty) {
      return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          Icon(Icons.star_border_rounded, color: metaColor, size: 20),
          AppText(
            avgText,
            maxLines: 1,
            style: (c) => AppTextStyles.textFieldHeading(
              c,
              fontWeight: FontWeight.w600,
            ).copyWith(height: 1, fontSize: 14),
          ),
          if (count > 0)
            AppText(
              '($count ${context.l10n.reviews})',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: (c) => AppTextStyles.helpAndSupportItemSubLabel(
                c,
              ).copyWith(height: 1.2, fontSize: 14),
            ),
        ],
      );
    }

    if (count > 0) {
      return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          Icon(Icons.star_border_rounded, color: metaColor, size: 20),
          AppText(
            '($count ${context.l10n.reviews})',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: (c) => AppTextStyles.helpAndSupportItemSubLabel(
              c,
            ).copyWith(height: 1.2, fontSize: 14),
          ),
        ],
      );
    }

    return Center(
      child: Icon(Icons.star_border_rounded, color: metaColor, size: 20),
    );
  }
}

class _ApiCertificationsCard extends StatelessWidget {
  const _ApiCertificationsCard({required this.certifications});

  final List<TrainerCertification> certifications;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            context.l10n.certificationsTraining,
            style: (c) => AppTextStyles.gelasioRegular(
              c,
              fontWeight: FontWeight.w400,
            ).copyWith(height: 1.55),
          ),
          SizedBox(height: AppSpacing.xs),
          for (final cert in certifications) _CertRow(cert: cert),
        ],
      ),
    );
  }
}

class _CertRow extends StatelessWidget {
  const _CertRow({required this.cert});

  final TrainerCertification cert;

  @override
  Widget build(BuildContext context) {
    final name = cert.name;
    final issuer = cert.issuer;
    final line = issuer != null && issuer.isNotEmpty ? '$name · $issuer' : name;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '• ',
          style: (c) => AppTextStyles.bodyText(c).copyWith(height: 1.55),
        ),
        Expanded(
          child: AppText(
            line,
            style: (c) => AppTextStyles.bodyText(c).copyWith(height: 1.55),
          ),
        ),
      ],
    );
  }
}

class _TrainerDetailsDemoView extends StatelessWidget {
  const _TrainerDetailsDemoView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.trainerDetails,
        isMoreMenu: false,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/demo images/Trainer Avatar.png',
                  height: 90,
                  width: 90,
                ),
              ),
              SizedBox(height: AppSpacing.base),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppText(
                  'Aisha Sherin',
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style: (c) =>
                      AppTextStyles.heading1(c).copyWith(height: 1.55),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppText(
                  context.l10n.powerPilatesSpecialist,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: (c) =>
                      AppTextStyles.bodyText(c).copyWith(height: 1.55),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 2,
                  runSpacing: AppSpacing.xs,
                  children: [
                    Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
                    Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
                    Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
                    Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
                    AppText(
                      '4',
                      maxLines: 1,
                      style: (c) => AppTextStyles.textFieldHeading(
                        c,
                        fontWeight: FontWeight.w600,
                      ).copyWith(height: 1, fontSize: 14),
                    ),
                    AppText(
                      '(127 ${context.l10n.reviews})',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: (c) => AppTextStyles.helpAndSupportItemSubLabel(
                        c,
                      ).copyWith(height: 1.2, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: AppSpacing.sm,
                  children: [
                    TagChip(
                      label: context.l10n.yearsExperience(8),
                      fontSize: 14,
                    ),
                    TagChip(label: context.l10n.matCertified, fontSize: 14),
                    TagChip(label: context.l10n.reformer, fontSize: 14),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: _TrainerDetailsDemoView._totalCard(
                        value: '350+',
                        label: context.l10n.classesTaught,
                        isDark: isDark,
                        context: context,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _TrainerDetailsDemoView._totalCard(
                        value: '23',
                        label: context.l10n.thisWeek,
                        isDark: isDark,
                        context: context,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _TrainerDetailsDemoView._totalCard(
                        value: '92%',
                        label: context.l10n.returnRate,
                        isDark: isDark,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppText(
                  '${context.l10n.about} Aisha',
                  style: (c) => AppTextStyles.gelasioRegular(c),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppText(
                  context.l10n.trainerAboutDescription,
                  style: (c) =>
                      AppTextStyles.bodyText(c).copyWith(height: 1.55),
                  maxLines: 12,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              _TrainerDetailsDemoView._demoCertificateTrainingCard(
                isDark: isDark,
                context: context,
              ),
              SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppText(
                  context.l10n.teachingStyle,
                  style: (c) =>
                      AppTextStyles.gelasioRegular(c).copyWith(height: 1.55),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _TrainerDetailsDemoView._teachingStyleCard(
                      label: context.l10n.dynamicTxt,
                      isDark: isDark,
                    ),
                    _TrainerDetailsDemoView._teachingStyleCard(
                      label: context.l10n.motivating,
                      isDark: isDark,
                    ),
                    _TrainerDetailsDemoView._teachingStyleCard(
                      label: context.l10n.detailOriented,
                      isDark: isDark,
                    ),
                    _TrainerDetailsDemoView._teachingStyleCard(
                      label: context.l10n.challenging,
                      isDark: isDark,
                    ),
                    _TrainerDetailsDemoView._teachingStyleCard(
                      label: context.l10n.supporting,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              const ClassReviewsSection(),
              SizedBox(height: AppSpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppText(
                  context.l10n.upcomingClasses,
                  style: (c) => AppTextStyles.heading1(c).copyWith(
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.base),
              BookingClassCard(
                title: 'Power Pilates',
                trainerName: 'Sarah Mitchell',
                studio: context.l10n.branchDowntown,
                time: '${context.l10n.today}, 6:00 PM',
                spotsLeft: 3,
                isInPlan: true,
              ),
              const SizedBox(height: AppSpacing.md),
              BookingClassCard(
                title: 'Power Pilates',
                trainerName: 'Sarah Mitchell',
                studio: context.l10n.branchDowntown,
                time: '${context.l10n.today}, 6:00 PM',
                spotsLeft: 0,
                isInPlan: false,
                upgradeRequired: true,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _totalCard({
    required String label,
    required String value,
    required bool isDark,
    required BuildContext context,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
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
            style: (c) => AppTextStyles.bottomSheetTitle(
              c,
              fontWeight: FontWeight.w600,
            ).copyWith(height: 1.55),
          ),
          SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: AppText(
              label,
              maxLines: 4,
              textAlign: TextAlign.center,
              style: (c) =>
                  AppTextStyles.caption(c).copyWith(height: 1.30, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _demoCertificateTrainingCard({
    required bool isDark,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            context.l10n.certificationsTraining,
            style: (c) => AppTextStyles.gelasioRegular(
              c,
              fontWeight: FontWeight.w400,
            ).copyWith(height: 1.55),
          ),
          SizedBox(height: AppSpacing.xs),
          _demoRow(
            label: context.l10n.pmaCertifiedInstructor,
            context: context,
          ),
          _demoRow(label: context.l10n.matPilatesLevel3, context: context),
          _demoRow(
            label: context.l10n.sportsRehabilitationTraining,
            context: context,
          ),
          _demoRow(
            label: context.l10n.anatomyBiomechanicsCertificate,
            context: context,
          ),
        ],
      ),
    );
  }

  static Widget _demoRow({
    required String label,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '• ',
          style: (c) => AppTextStyles.bodyText(c).copyWith(height: 1.55),
        ),
        Expanded(
          child: AppText(
            label,
            style: (c) => AppTextStyles.bodyText(c).copyWith(height: 1.55),
          ),
        ),
      ],
    );
  }

  static Widget _teachingStyleCard({
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.greyContainerBg,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: Builder(
        builder: (context) =>
            AppText(label, style: (c) => AppTextStyles.textFieldHeading(c)),
      ),
    );
  }
}
