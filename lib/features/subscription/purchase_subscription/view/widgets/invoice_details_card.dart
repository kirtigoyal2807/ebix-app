import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/checkout/data/models/membership_receipt_summary.dart';

import '../../../../../config/theme/app_text_styles.dart';
import '../../../../../core/localization/localization_extension.dart';
import '../../../../../widgets/app_text.dart';
import 'package:pilates_app/config/theme/app_radius.dart';

class InvoiceDetailsCard extends StatelessWidget {
  const InvoiceDetailsCard({super.key, this.receipt});

  /// When set (after checkout / payment intent), shows server-backed lines.
  final MembershipReceiptSummary? receipt;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = Localizations.localeOf(context).languageCode;
    final r = receipt;
    final cur = r?.currency ?? 'SAR';

    return CustomPaint(
      painter: ReceiptBorderPainter(),
      child: ClipPath(
        clipper: ReceiptClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.trainerBlackBackgroundColor
                : Colors.white,
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 5.6,
                      offset: const Offset(0, 2.24),
                      spreadRadius: 0,
                    ),
                  ],
          ),
          padding: const EdgeInsets.only(
            top: 22,
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.invoiceDetails,
                    style: (context) => AppTextStyles.textFieldHeading(
                      context,
                    ).copyWith(fontSize: 14, height: 1.55),
                  ),
                  SvgPicture.asset(
                    isDark
                        ? "assets/images/svg/ic_dark_the_pilates_studio.svg"
                        : "assets/images/svg/ic_the_pilates_studio.svg",
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              if (r == null) ...[
                AppText(
                  context.l10n.invoiceHistorySubtitle,
                  style: (context) =>
                      AppTextStyles.textFieldHeading(context).copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.darkGreyText
                            : AppColors.lightGrey,
                        height: 1.45,
                      ),
                ),
              ] else ...[
                AppText(
                  context.l10n.invoiceNumber(r.displayInvoiceCode ?? '—'),
                  style: (context) =>
                      AppTextStyles.textFieldHeading(context).copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.darkGreyText
                            : AppColors.lightGrey,
                      ),
                ),
                AppText(
                  _paidDateLine(r, lang),
                  style: (context) =>
                      AppTextStyles.textFieldHeading(context).copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.darkGreyText
                            : AppColors.lightGrey,
                      ),
                ),
                const SizedBox(height: 64),
                _buildRow(
                  context,
                  r.planName?.trim().isNotEmpty == true
                      ? r.planName!.trim()
                      : context.l10n.premiumPlanMonthly,
                  MembershipReceiptSummary.formatMoney(
                    r.subtotalMinor ?? r.totalMinor,
                    cur,
                    lang,
                  ),
                  isDark,
                ),
                if (r.setupFeeMinor != null && r.setupFeeMinor != 0) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _buildRow(
                    context,
                    context.l10n.setupFee,
                    MembershipReceiptSummary.formatMoney(
                      r.setupFeeMinor,
                      cur,
                      lang,
                    ),
                    isDark,
                  ),
                ],
                if (r.taxMinor != null && r.taxMinor != 0) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _buildRow(
                    context,
                    context.l10n.tax,
                    MembershipReceiptSummary.formatMoney(r.taxMinor, cur, lang),
                    isDark,
                  ),
                ],
                if (r.discountMinor != null && r.discountMinor != 0) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _buildRow(
                    context,
                    context.l10n.discount,
                    '-${MembershipReceiptSummary.formatMoney(r.discountMinor, cur, lang)}',
                    isDark,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Divider(
                  color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildRow(
                  context,
                  context.l10n.totalPaid,
                  MembershipReceiptSummary.formatMoney(r.totalMinor, cur, lang),
                  isDark,
                  isBold: true,
                ),
                const SizedBox(height: AppSpacing.md),
                Divider(
                  color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildRow(
                  context,
                  context.l10n.paymentMethod,
                  r.paymentMethodLine('PayTabs'),
                  isDark,
                ),
                if (r.nextBillingAtIso != null &&
                    r.nextBillingAtIso!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _buildRow(
                    context,
                    context.l10n.nextBillingDateText,
                    MembershipReceiptSummary.formatNextBilling(
                          r.nextBillingAtIso,
                          lang,
                        ) ??
                        r.nextBillingAtIso!.trim(),
                    isDark,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _paidDateLine(MembershipReceiptSummary r, String languageCode) {
    final raw = r.paidAtIso?.trim();
    if (raw == null || raw.isEmpty) {
      return 'Date: —';
    }
    final formatted =
        MembershipReceiptSummary.formatPaidDate(raw, languageCode) ??
        MembershipReceiptSummary.shortDateFromIso(raw) ??
        raw;
    return 'Date: $formatted';
  }

  static Widget _buildRow(
    BuildContext context,
    String title,
    String value,
    bool isDark, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          title,
          style: (context) => AppTextStyles.textFieldHeading(context).copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.lightGrey,
            height: 1.2,
          ),
        ),

        AppText(
          value,
          style: (context) => AppTextStyles.textFieldHeading(context).copyWith(
            fontSize: 12,
            color: isDark ? AppColors.darkGreyText : AppColors.greyText,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

// class ReceiptClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     const double topRadius = 12;
//     const double bottomRadius = 12;
//     const double cutRadius = 12;
//     const int cutCount = 9;
//     const double horizontalPadding = 20;
//
//     final path = Path();
//
//     // ---- Top Left Rounded ----
//     path.moveTo(0, topRadius);
//     path.quadraticBezierTo(0, 0, topRadius, 0);
//
//     // ---- Top Line ----
//     path.lineTo(size.width - topRadius, 0);
//
//     // ---- Top Right Rounded ----
//     path.quadraticBezierTo(size.width, 0, size.width, topRadius);
//
//     // ---- Right Side ----
//     path.lineTo(size.width, size.height - cutRadius - bottomRadius);
//
//     // ---- Bottom Right Rounded ----
//     path.quadraticBezierTo(
//       size.width,
//       size.height - cutRadius,
//       size.width - bottomRadius,
//       size.height - cutRadius,
//     );
//
//     // ---- Bottom Right Flat Space ----
//     path.lineTo(size.width - horizontalPadding, size.height - cutRadius);
//
//     // ---- Bottom Cuts ----
//     double availableWidth = size.width - (horizontalPadding * 2);
//     double sectionWidth = availableWidth / cutCount;
//
//     for (int i = cutCount; i > 0; i--) {
//       double centerX =
//           horizontalPadding + (sectionWidth * i) - sectionWidth / 2;
//
//       path.arcTo(
//         Rect.fromCircle(
//           center: Offset(centerX, size.height),
//           radius: cutRadius,
//         ),
//         0,
//         -3.1416,
//         false,
//       );
//     }
//
//     // ---- Bottom Left Flat Space ----
//     path.lineTo(horizontalPadding, size.height - cutRadius);
//
//     // ---- Bottom Left Rounded ----
//     path.quadraticBezierTo(
//       0,
//       size.height - cutRadius,
//       0,
//       size.height - cutRadius - bottomRadius,
//     );
//
//     // ---- Left Side ----
//     path.lineTo(0, topRadius);
//
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double topRadius = 12;
    const double bottomRadius = 12;
    const double cutRadius = 12;
    const int cutCount = 9;

    final path = Path();

    // ---- Top Left Rounded ----
    path.moveTo(0, topRadius);
    path.quadraticBezierTo(0, 0, topRadius, 0);

    // ---- Top Line ----
    path.lineTo(size.width - topRadius, 0);

    // ---- Top Right Rounded ----
    path.quadraticBezierTo(size.width, 0, size.width, topRadius);

    // ---- Right Side ----
    path.lineTo(size.width, size.height - bottomRadius);

    // ---- Bottom Right Rounded ----
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - bottomRadius,
      size.height,
    );

    // ---- Bottom Cuts Area ----
    double availableWidth = size.width - (bottomRadius * 2);
    double sectionWidth = availableWidth / cutCount;

    for (int i = cutCount; i > 0; i--) {
      double centerX = bottomRadius + (sectionWidth * i) - sectionWidth / 2;

      path.arcTo(
        Rect.fromCircle(
          center: Offset(centerX, size.height),
          radius: cutRadius,
        ),
        0,
        -3.1416,
        false,
      );
    }

    // ---- Bottom Left Rounded ----

    path.quadraticBezierTo(0, size.height, 0, size.height - bottomRadius);

    // ---- Left Side ----
    path.lineTo(0, topRadius);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ReceiptBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = ReceiptClipper().getClip(size);

    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
