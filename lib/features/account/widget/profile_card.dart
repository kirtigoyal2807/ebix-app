import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        // color: AppColors.splashBackgroundDark,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.subscriptionCardGradient1,
            AppColors.subscriptionCardGradient2,
          ],
          stops: [0.15, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // /// LEFT BIG CIRCLE
          // Positioned(
          //   left: -185,
          //   top: -98,
          //   child: Container(
          //     height: 416,
          //     width: 416,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.white.withOpacity(0.12),
          //     ),
          //   ),
          // ),
          //
          // /// RIGHT BOTTOM CIRCLE
          // Positioned(
          //   top: 103,
          //   left: 176,
          //   child: Opacity(
          //     opacity: 0.6,
          //     child: Transform.rotate(
          //       angle: 90 * 3.1415926535 / 180, // 90° to radians
          //       child: ShaderMask(
          //         blendMode: BlendMode.lighten,
          //         shaderCallback: (bounds) {
          //           return const LinearGradient(
          //             begin: Alignment.centerRight, // 270deg
          //             end: Alignment.centerLeft,
          //             stops: [-0.44, 0.625], // -44.38%, 62.5%
          //             colors: [
          //               Color(0xFFDEB994),
          //               Color(0x00876335),
          //             ],
          //           ).createShader(bounds);
          //         },
          //         child: Container(
          //           width: 210,
          //           height: 209,
          //           decoration: const BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Colors.white, // required for ShaderMask
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // SvgPicture.asset(
          //   "assets/images/svg/ic_account_card_bg.svg",
          //   width: double.infinity,
          //   fit: BoxFit.fill,
          // ),

          /// CONTENT
          Padding(
            padding: EdgeInsets.all(AppSpacing.lmd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                            "assets/images/demo images/Trainer Avatar.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    /// BASIC BADGE
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                        horizontal: AppSpacing.base,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.seekBarLight,
                        borderRadius: BorderRadius.circular(AppRadius.base),
                      ),
                      child: AppText(
                        context.l10n.basic,
                        style: (context) =>
                            AppTextStyles.body(context).copyWith(
                              fontSize: 12,
                              height: 1,
                              color: AppColors.languageIcon,
                            ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.xl),
                AppText(
                  "Jenny Wilson",
                  style: (context) => AppTextStyles.gelasioMedium(
                    context,
                  ).copyWith(color: Colors.white, height: 1),
                ),
                SizedBox(height: AppSpacing.sm),
                AppText(
                  "jennywilson@gmail.com",
                  style: (context) => AppTextStyles.bodyText(
                    context,
                  ).copyWith(color: Colors.white, height: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
