import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassDetailHeader extends StatelessWidget {
  const ClassDetailHeader({super.key, required this.slot});

  final ClassSlotViewModel slot;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    final desc = slot.description?.trim();
    final baseBody = AppTextStyles.bodyText(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        // Hero image — use network image if available, fallback to asset
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg + 4),
          child: slot.imageUrl != null && slot.imageUrl!.isNotEmpty
              ? Image.network(
                  slot.imageUrl!,
                  height: size.height * 0.28,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/demo images/Class Image.png',
                    height: size.height * 0.28,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  'assets/images/demo images/Class Image.png',
                  height: size.height * 0.28,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Title and rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    slot.name,
                    style: (ctx) => AppTextStyles.heading1(ctx).copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      height: 1.55,
                    ),
                  ),
                  if (desc != null && desc.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Html(
                      data: desc,
                      shrinkWrap: true,
                      style: {
                        'body': Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          fontSize: FontSize(baseBody.fontSize ?? 14),
                          color: baseBody.color,
                          fontFamily: baseBody.fontFamily,
                        ),
                        'p': Style(
                          margin: Margins.only(bottom: 8),
                        ),
                        'ul': Style(
                          margin: Margins.only(bottom: 8),
                        ),
                        'ol': Style(
                          margin: Margins.only(bottom: 8),
                        ),
                      },
                      onLinkTap: (url, attributes, element) async {
                        if (url == null || url.isEmpty) return;
                        final uri = Uri.tryParse(url.trim());
                        if (uri == null) return;
                        try {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (_) {}
                      },
                    ),
                  ],
                ],
              ),
            ),
            if (slot.averageRatingDisplayLabel != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.goldStarColor,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    AppText(
                      slot.averageRatingDisplayLabel!,
                      style: (ctx) => AppTextStyles.boldBody(ctx).copyWith(
                        fontSize: 18,
                        color: isDark
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
