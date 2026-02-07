import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/cubit/class_detail/class_detail_cubit.dart';
import 'package:pilates_app/features/booking/cubit/class_detail/class_detail_state.dart';
import 'package:pilates_app/features/booking/widgets/class_detail/class_detail_header.dart';
import 'package:pilates_app/features/booking/widgets/class_detail/class_info_grid.dart';
import 'package:pilates_app/features/booking/widgets/class_detail/class_location_card.dart';
import 'package:pilates_app/features/booking/widgets/class_detail/class_about_section.dart';
import 'package:pilates_app/features/booking/widgets/class_detail/class_what_to_bring.dart';
import 'package:pilates_app/features/booking/widgets/class_detail/class_reviews_section.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ClassDetailView extends StatelessWidget {
  const ClassDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClassDetailCubit()..loadClassDetails(),
      child: const ClassDetailBody(),
    );
  }
}

class ClassDetailBody extends StatelessWidget {
  const ClassDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward_ios
                : Icons.arrow_back_ios_new,
            color: isDark ? AppColors.whiteColor : AppColors.blackColor,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppText(
          context.l10n.classDetails,
          style: (context) => AppTextStyles.appBarTitle(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ClassDetailCubit, ClassDetailState>(
        builder: (context, state) {
          if (state is ClassDetailLoading) {
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
                    SizedBox(height: AppSpacing.xl),
                    ClassInfoGrid(),
                    SizedBox(height: AppSpacing.xl),
                    ClassLocationCard(),
                    SizedBox(height: AppSpacing.xl),
                    ClassAboutSection(),
                    SizedBox(height: AppSpacing.xl),
                    ClassWhatToBring(),
                    SizedBox(height: AppSpacing.xl),
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
                    onPressed: () => context.read<ClassDetailCubit>().bookClass(),
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
