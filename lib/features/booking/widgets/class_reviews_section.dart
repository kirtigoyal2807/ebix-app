import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/data/models/review_resource.dart';
import 'package:pilates_app/features/booking/data/models/reviews_list_result.dart';
import 'package:pilates_app/features/booking/data/reviews_repository.dart';
import 'package:pilates_app/features/booking/widgets/trainer_average_stars.dart';
import 'package:pilates_app/widgets/app_text.dart';

/// When [reviewableType] + [reviewableId] are set: `GET /reviews` (§14.1).
///
/// Optional [summaryAvgRating], [summaryReviewsCount], and [summaryRatingBreakdown]
/// mirror list/detail payloads (`avgRating`, `reviewsCount`, `ratingBreakdown`) so the
/// summary + distribution bars reflect **all** reviews, not only the first page of rows.
class ClassReviewsSection extends StatelessWidget {
  const ClassReviewsSection({
    super.key,
    this.reviewableType,
    this.reviewableId,
    this.embeddedRecentReviews,
    this.summaryAvgRating,
    this.summaryReviewsCount,
    this.summaryRatingBreakdown,
  });

  final String? reviewableType;
  final String? reviewableId;

  /// From `GET /classes`, `GET /classes/events/{id}` nested `class`, or trainer detail
  /// when the payload includes `recentReviews` (use `[]` for none).
  final List<ReviewResource>? embeddedRecentReviews;

  /// API aggregate average (e.g. trainer `avgRating` or class average as string).
  final String? summaryAvgRating;

  /// Total review count from API (`reviewsCount`).
  final int? summaryReviewsCount;

  /// Five counts: index 0 = 5★ … index 4 = 1★ (`ratingBreakdown`).
  final List<int>? summaryRatingBreakdown;

  @override
  Widget build(BuildContext context) {
    if (embeddedRecentReviews != null) {
      return _EmbeddedRecentReviewsBody(
        reviews: embeddedRecentReviews!,
        summaryAvgRating: summaryAvgRating,
        summaryReviewsCount: summaryReviewsCount,
        summaryRatingBreakdown: summaryRatingBreakdown,
      );
    }
    final t = reviewableType?.trim();
    final id = reviewableId?.trim();
    if (t == null || t.isEmpty || id == null || id.isEmpty) {
      return const _StaticClassReviewsBody();
    }
    return _DynamicReviewsSection(
      reviewableType: t,
      reviewableId: id,
      summaryAvgRating: summaryAvgRating,
      summaryReviewsCount: summaryReviewsCount,
      summaryRatingBreakdown: summaryRatingBreakdown,
    );
  }
}

/// Trainer (or other) payload already includes review rows; empty list → [noReviewsYet] UI.
class _EmbeddedRecentReviewsBody extends StatelessWidget {
  const _EmbeddedRecentReviewsBody({
    required this.reviews,
    this.summaryAvgRating,
    this.summaryReviewsCount,
    this.summaryRatingBreakdown,
  });

  final List<ReviewResource> reviews;
  final String? summaryAvgRating;
  final int? summaryReviewsCount;
  final List<int>? summaryRatingBreakdown;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  context.l10n.recentReviews,
                  maxLines: 2,
                  style: (context) => AppTextStyles.heading1(context).copyWith(
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                    fontSize: size.width * 0.055 > 18 ? 18 : size.width * 0.055,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        _DynamicReviewsContent(
          reviews: reviews,
          isDark: isDark,
          summaryAvgRating: summaryAvgRating,
          summaryReviewsCount: summaryReviewsCount,
          summaryRatingBreakdown: summaryRatingBreakdown,
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

// --- API-driven reviews ---

class _DynamicReviewsSection extends StatefulWidget {
  const _DynamicReviewsSection({
    required this.reviewableType,
    required this.reviewableId,
    this.summaryAvgRating,
    this.summaryReviewsCount,
    this.summaryRatingBreakdown,
  });

  final String reviewableType;
  final String reviewableId;
  final String? summaryAvgRating;
  final int? summaryReviewsCount;
  final List<int>? summaryRatingBreakdown;

  @override
  State<_DynamicReviewsSection> createState() => _DynamicReviewsSectionState();
}

class _DynamicReviewsSectionState extends State<_DynamicReviewsSection> {
  Future<ApiResult<ReviewsListResult>>? _future;
  var _inited = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inited) return;
    _inited = true;
    _future = context.read<ReviewsRepository>().listReviews(
          reviewableType: widget.reviewableType,
          reviewableId: widget.reviewableId,
        );
  }

  Future<void> _retry() async {
    setState(() {
      _future = context.read<ReviewsRepository>().listReviews(
            reviewableType: widget.reviewableType,
            reviewableId: widget.reviewableId,
          );
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  context.l10n.recentReviews,
                  maxLines: 2,
                  style: (context) => AppTextStyles.heading1(context).copyWith(
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                    fontSize: size.width * 0.055 > 18 ? 18 : size.width * 0.055,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        FutureBuilder<ApiResult<ReviewsListResult>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            final data = snapshot.data!;
            return data.when(
              success: (raw, _) {
                final list = raw.items;
                return _DynamicReviewsContent(
                  reviews: list,
                  isDark: isDark,
                  summaryAvgRating: widget.summaryAvgRating,
                  summaryReviewsCount: widget.summaryReviewsCount,
                  summaryRatingBreakdown: widget.summaryRatingBreakdown,
                );
              },
              failure: (e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
                  child: Column(
                    children: [
                      AppText(
                        e.message ?? 'Request failed',
                        maxLines: 4,
                        style: (c) => AppTextStyles.bodyText(c).copyWith(color: AppColors.error),
                      ),
                      TextButton(
                        onPressed: _retry,
                        child: AppText('Retry', style: (c) => AppTextStyles.body(c)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _DynamicReviewsContent extends StatelessWidget {
  const _DynamicReviewsContent({
    required this.reviews,
    required this.isDark,
    this.summaryAvgRating,
    this.summaryReviewsCount,
    this.summaryRatingBreakdown,
  });

  final List<ReviewResource> reviews;
  final bool isDark;
  final String? summaryAvgRating;
  final int? summaryReviewsCount;
  final List<int>? summaryRatingBreakdown;

  static double? _parseAvgString(String? raw) {
    if (raw == null) return null;
    var t = raw.trim();
    if (t.isEmpty || t == '—' || t == '-') return null;
    return double.tryParse(t.replaceAll(',', '.'));
  }

  static String _formatAverage(double v) {
    if (v <= 0) return '—';
    if (v == v.roundToDouble()) return v.round().toString();
    return v.toStringAsFixed(1);
  }

  static String _formatSingleReviewRating(double r) {
    if (r <= 0) return '—';
    if (r == r.roundToDouble()) return r.round().toString();
    return r.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final bd = summaryRatingBreakdown;
    final bdTotal = (bd != null && bd.length == 5)
        ? bd.fold<int>(0, (a, b) => a + b)
        : 0;
    final listLen = reviews.length;
    final displayCount = (summaryReviewsCount != null && summaryReviewsCount! > 0)
        ? summaryReviewsCount!
        : (bdTotal > 0 ? bdTotal : listLen);

    if (reviews.isEmpty && displayCount == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
        child: AppText(
          context.l10n.noReviewsYet,
          style: (c) => AppTextStyles.bodyText(c).copyWith(color: AppColors.lightGrey),
        ),
      );
    }

    final parsedAgg = _parseAvgString(summaryAvgRating);
    double averageFromList() {
      if (reviews.isEmpty) return 0;
      return reviews.fold<double>(0, (s, r) => s + r.rating) / reviews.length;
    }

    double averageFromBreakdown() {
      if (bd == null || bd.length != 5 || bdTotal <= 0) return 0;
      var w = 0.0;
      for (var i = 0; i < 5; i++) {
        w += (5 - i) * bd[i];
      }
      return w / bdTotal;
    }

    final displayAverage = () {
      if (parsedAgg != null && displayCount > 0) return parsedAgg;
      if (reviews.isNotEmpty) return averageFromList();
      if (bdTotal > 0) return averageFromBreakdown();
      return 0.0;
    }();

    final avgText = _formatAverage(displayAverage);
    final barDenominator = bdTotal > 0 ? bdTotal : (reviews.isNotEmpty ? reviews.length : 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      avgText,
                      maxLines: 1,
                      style: (context) => AppTextStyles.bottomSheetTitle(
                        context,
                      ).copyWith(fontSize: 32, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (displayAverage > 0)
                            TrainerAverageStars(
                              rating: displayAverage.clamp(0, 5),
                              itemSize: 14,
                            )
                          else
                            const _StarRating(rating: 0, size: 14),
                          const SizedBox(height: 4),
                          AppText(
                            context.l10n.basedOnReviews(displayCount),
                            maxLines: 2,
                            style: (context) =>
                                AppTextStyles.captionText(context).copyWith(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkGreyText
                                  : AppColors.greyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Column(
                  children: List.generate(5, (i) {
                    final stars = 5 - i;
                    final int c;
                    if (bd != null && bd.length == 5 && bdTotal > 0) {
                      c = bd[i];
                    } else if (reviews.isNotEmpty) {
                      c = reviews
                          .where((r) => r.rating.round().clamp(1, 5) == stars)
                          .length;
                    } else {
                      c = 0;
                    }
                    final p = barDenominator > 0 ? c / barDenominator : 0.0;
                    return _RatingBar(
                      stars: stars,
                      progress: p,
                      count: c,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        if (reviews.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 168,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: reviews.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) => Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? AppSpacing.lg : 0,
                    right: index == reviews.length - 1 ? AppSpacing.lg : 0,
                  ),
                  child: _ApiReviewCard(review: reviews[index]),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ApiReviewCard extends StatelessWidget {
  const _ApiReviewCard({required this.review});

  final ReviewResource review;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final name = review.reviewer.name?.trim();
    final displayName = (name == null || name.isEmpty) ? '—' : name;
    final when = _formatDate(context, review.createdAt, locale);
    final body = review.body?.trim();
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.75,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: (context) => AppTextStyles.boldBody(context).copyWith(
                        color: isDark ? AppColors.lightText : AppColors.darkText,
                      ),
                    ),
                    AppText(
                      when,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: (context) => AppTextStyles.helpAndSupportItemSubLabel(context),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    color: AppColors.goldStarColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  AppText(
                    _DynamicReviewsContent._formatSingleReviewRating(review.rating),
                    maxLines: 1,
                    style: (context) => AppTextStyles.boldBody(context).copyWith(
                      fontSize: 14,
                      color: isDark ? AppColors.lightText : AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (body != null && body.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            AppText(
              body,
              style: (context) => AppTextStyles.bodyText(context).copyWith(height: 1.3),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime utc, Locale locale) {
    try {
      return DateFormat.yMMMd(locale.toString()).add_jm().format(utc.toLocal());
    } catch (_) {
      return DateFormat('y-MM-dd').format(utc.toLocal());
    }
  }
}

// --- Original static demo (unchanged) ---

class _StaticClassReviewsBody extends StatelessWidget {
  const _StaticClassReviewsBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  context.l10n.recentReviews,
                  maxLines: 2,
                  style: (context) => AppTextStyles.heading1(context).copyWith(
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                    fontSize: size.width * 0.055 > 18 ? 18 : size.width * 0.055,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: AppText(
                  context.l10n.seeAll,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  style: (context) =>
                      AppTextStyles.captionText(context, fontWeight: FontWeight.w500).copyWith(
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
        const SizedBox(height: AppSpacing.base),

        // Reviews Summary
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      '4.8',
                      maxLines: 1,
                      style: (context) => AppTextStyles.bottomSheetTitle(
                        context,
                      ).copyWith(fontSize: 32, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _StarRating(rating: 5, size: 14),
                          const SizedBox(height: 4),
                          AppText(
                            context.l10n.basedOnReviews(27),
                            maxLines: 2,
                            style: (context) =>
                                AppTextStyles.captionText(context).copyWith(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkGreyText
                                      : AppColors.greyText,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                const Column(
                  children: [
                    _RatingBar(stars: 5, progress: 0.6, count: 16),
                    _RatingBar(stars: 4, progress: 0.2, count: 5),
                    _RatingBar(stars: 3, progress: 0.1, count: 3),
                    _RatingBar(stars: 2, progress: 0.05, count: 1),
                    _RatingBar(stars: 1, progress: 0.05, count: 1),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Review Cards - Horizontal
        const SizedBox(
          height: 168,
          child: _StaticReviewCardsList(),
        ),
      ],
    );
  }
}

class _StaticReviewCardsList extends StatelessWidget {
  const _StaticReviewCardsList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
      itemBuilder: (context, index) => Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? AppSpacing.lg : 0,
            right: index == 2 ? AppSpacing.lg : 0,
          ),
          child: const _DemoReviewCard(),
        ),
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int stars;
  final double progress;
  final int count;

  const _RatingBar({
    required this.stars,
    required this.progress,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Row(
        children: [
          const Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
          const SizedBox(width: 4),
          AppText(
            stars.toString(),
            style: (context) => AppTextStyles.helpAndSupportItemLabel(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark
                    ? AppColors.primaryDarkButton
                    : AppColors.ratingBarBackground,
                color: AppColors.goldStarColor,
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppText(
            count.toString(),
            style: (context) => AppTextStyles.captionText(
              context,
            ).copyWith(fontSize: 14, color: AppColors.lightGrey),
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final int rating;
  final double size;

  const _StarRating({required this.rating, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: const Color(0xFFEAB308),
          size: size,
        );
      }),
    );
  }
}

class _DemoReviewCard extends StatelessWidget {
  const _DemoReviewCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: MediaQuery.sizeOf(context).width * 0.75,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      context.l10n.reviewerName1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: (context) => AppTextStyles.boldBody(context).copyWith(
                        color: isDark
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                    ),
                    AppText(
                      context.l10n.reviewerTime1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: (context) => AppTextStyles.helpAndSupportItemSubLabel(context),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: AppColors.goldStarColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  AppText(
                    '4.5',
                    maxLines: 1,
                    style: (context) => AppTextStyles.boldBody(context).copyWith(
                      fontSize: 14,
                      color: isDark ? AppColors.lightText : AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            context.l10n.reviewerComment1,
            style: (context) => AppTextStyles.bodyText(context).copyWith(height: 1.3),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
