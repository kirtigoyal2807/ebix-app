import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';

import '../../../../../config/theme/app_text_styles.dart';
import '../../../../../core/localization/localization_extension.dart';
import '../../../../../widgets/app_text.dart';

class InvoiceDetailsCard extends StatelessWidget {
  const InvoiceDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(
      painter: ReceiptBorderPainter(),
      child: ClipPath(
        clipper: ReceiptClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.trainerBlackBackgroundColor
                : Colors.white,
            boxShadow: [
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
                    ).copyWith(fontSize: 14,height: 1.55),
                  ),
                  SvgPicture.asset(
                    isDark
                        ? "assets/images/svg/ic_dark_the_pilates_studio.svg"
                        : "assets/images/svg/ic_the_pilates_studio.svg",
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              AppText(
                context.l10n.invoiceNumber('#2026-0123-456'),
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
                context.l10n.invoiceDate,
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

              _buildRow(context.l10n.premiumPlanMonthly, "\$89.00", isDark),
              const SizedBox(height: AppSpacing.xs),
              _buildRow(context.l10n.setupFee, "\$0.00", isDark),
              const SizedBox(height: AppSpacing.xs),
              _buildRow(context.l10n.discount, "-\$10.00", isDark),
              const SizedBox(height: AppSpacing.xs),
              _buildRow(context.l10n.tax, "\$6.32", isDark),

              const SizedBox(height: AppSpacing.md),
              Divider(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                height: 1,
              ),
              const SizedBox(height: AppSpacing.md),

              _buildRow(
                context.l10n.totalPaid,
                "\$85.32",
                isDark,
                isBold: true,
              ),

              const SizedBox(height: AppSpacing.md),
              Divider(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                height: 1,
              ),
              const SizedBox(height: AppSpacing.md),

              _buildRow(context.l10n.paymentMethod, "•••• 3456", isDark),
              const SizedBox(height: AppSpacing.xs),
              _buildRow(
                context.l10n.nextBillingDateText,
                "Feb 23, 2026",
                isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildRow(
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



class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double topRadius = 12;
    const double bottomRadius = 12;
    const double cutRadius = 12;
    const int cutCount = 9;
    const double horizontalPadding = 20;

    final path = Path();

    // ---- Top Left Rounded ----
    path.moveTo(0, topRadius);
    path.quadraticBezierTo(0, 0, topRadius, 0);

    // ---- Top Line ----
    path.lineTo(size.width - topRadius, 0);

    // ---- Top Right Rounded ----
    path.quadraticBezierTo(size.width, 0, size.width, topRadius);

    // ---- Right Side ----
    path.lineTo(size.width, size.height - cutRadius - bottomRadius);

    // ---- Bottom Right Rounded ----
    path.quadraticBezierTo(
      size.width,
      size.height - cutRadius,
      size.width - bottomRadius,
      size.height - cutRadius,
    );

    // ---- Bottom Right Flat Space ----
    path.lineTo(size.width - horizontalPadding, size.height - cutRadius);

    // ---- Bottom Cuts ----
    double availableWidth = size.width - (horizontalPadding * 2);
    double sectionWidth = availableWidth / cutCount;

    for (int i = cutCount; i > 0; i--) {
      double centerX =
          horizontalPadding + (sectionWidth * i) - sectionWidth / 2;

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

    // ---- Bottom Left Flat Space ----
    path.lineTo(horizontalPadding, size.height - cutRadius);

    // ---- Bottom Left Rounded ----
    path.quadraticBezierTo(
      0,
      size.height - cutRadius,
      0,
      size.height - cutRadius - bottomRadius,
    );

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
