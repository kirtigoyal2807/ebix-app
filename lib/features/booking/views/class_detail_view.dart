import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/cubit/booking_cubit.dart';
import 'package:pilates_app/features/booking/cubit/booking_state.dart';
import 'package:pilates_app/features/booking/widgets/class_detail_header.dart';
import 'package:pilates_app/features/booking/widgets/class_info_grid.dart';
import 'package:pilates_app/features/booking/widgets/class_location_card.dart';
import 'package:pilates_app/features/booking/widgets/class_about_section.dart';
import 'package:pilates_app/features/booking/widgets/class_what_to_bring.dart';
import 'package:pilates_app/features/booking/widgets/class_reviews_section.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ClassDetailView extends StatelessWidget {
  const ClassDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      // backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppAppBar(
        onBack: () => Navigator.of(context).pop(),
        title: context.l10n.classDetails,
        isMoreMenu: false,
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state.classDetailStatus == ClassDetailStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: size.height * 0.15, // Space for sticky button
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClassDetailHeader(),
                    SizedBox(height: AppSpacing.lg),
                    ClassInfoGrid(),
                    SizedBox(height: AppSpacing.lg),
                    ClassLocationCard(),
                    SizedBox(height: AppSpacing.lg),
                    ClassAboutSection(),
                    SizedBox(height: AppSpacing.lg),
                    ClassWhatToBring(),
                    SizedBox(height: AppSpacing.lg),
                    ClassReviewsSection(),
                  ],
                ),
              ),

              // Sticky Button
              Positioned(
                left: 0,
                right: 0,
                bottom: size.height * 0.08,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: ElevatedButton(
                    onPressed: () => context.read<BookingCubit>().bookClass(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.splashBackgroundDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pillRadius),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: AppText(
                      context.l10n.bookThisClass,
                      style: (context) => AppTextStyles.button(context).copyWith(
                        fontSize: size.width * 0.04 > 16 ? 16 : size.width * 0.04,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
