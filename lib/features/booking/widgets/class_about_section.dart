import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassAboutSection extends StatelessWidget {
  const ClassAboutSection({super.key, required this.slot});

  final ClassSlotViewModel slot;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    final html = slot.description?.trim();
    if (html == null || html.isEmpty) {
      return const SizedBox.shrink();
    }

    final baseBody = AppTextStyles.bodyText(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          context.l10n.aboutThisClass,
          style: (ctx) => AppTextStyles.heading1(ctx).copyWith(
            color: isDark ? AppColors.lightText : AppColors.darkText,
            fontSize: size.width * 0.055 > 18 ? 18 : size.width * 0.055,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Html(
          data: html,
          shrinkWrap: true,
          style: {
            'body': Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              fontSize: FontSize(baseBody.fontSize ?? 14),
              color: baseBody.color,
              fontFamily: baseBody.fontFamily,
            ),
            'p': Style(margin: Margins.only(bottom: 8)),
            'h1': Style(margin: Margins.only(top: 8, bottom: 8)),
            'h2': Style(margin: Margins.only(top: 8, bottom: 8)),
            'h3': Style(margin: Margins.only(top: 8, bottom: 8)),
            'ul': Style(margin: Margins.only(bottom: 8)),
            'ol': Style(margin: Margins.only(bottom: 8)),
          },
          onLinkTap: (url, attributes, element) async {
            if (url == null || url.isEmpty) return;
            final uri = Uri.tryParse(url.trim());
            if (uri == null) return;
            try {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } catch (_) {}
          },
        ),
      ],
    );
  }
}
