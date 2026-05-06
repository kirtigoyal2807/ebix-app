import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/utils/api_media_url.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dropdown.dart';
import '../../../widgets/phone_number_field.dart';
import '../cubit/personal_info_cubit.dart';
import '../cubit/personal_info_state.dart';
import '../widget/profile_picture_bottom_sheet.dart';

class PersonalView extends StatelessWidget {
  const PersonalView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    return BlocProvider(
      create: (context) => PersonalInfoCubit(
        authRepository: context.read<AuthCubit>().authRepository,
        initialGender: _normalizeGenderValue(user?.gender),
        initialDateOfBirth: user?.dateOfBirth,
      ),
      child: _PersonalViewBody(initialUser: user),
    );
  }

  String? _normalizeGenderValue(String? gender) {
    final normalized = gender?.trim().toLowerCase();
    switch (normalized) {
      case 'male':
      case 'female':
      case 'other':
        return normalized;
      default:
        return null;
    }
  }
}

class _PersonalViewBody extends StatefulWidget {
  const _PersonalViewBody({this.initialUser});

  final AuthUser? initialUser;

  @override
  State<_PersonalViewBody> createState() => _PersonalViewBodyState();
}

class _PersonalViewBodyState extends State<_PersonalViewBody> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    final names = _namesFromUser(widget.initialUser);
    _firstNameController = TextEditingController(text: names.$1);
    _lastNameController = TextEditingController(text: names.$2);
    _emailController = TextEditingController(
      text: widget.initialUser?.email?.trim() ?? '',
    );
    _phoneController = TextEditingController(
      text: _nationalPhoneDigits(widget.initialUser?.phone),
    );
    _dobController = TextEditingController(
      text: _formatDate(widget.initialUser?.dateOfBirth),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  /// Returns `(firstName, lastName)` from [AuthUser], splitting [AuthUser.name] if needed.
  (String, String) _namesFromUser(AuthUser? u) {
    var fn = u?.firstName?.trim() ?? '';
    var ln = u?.lastName?.trim() ?? '';
    if (fn.isEmpty && ln.isEmpty) {
      final name = u?.name?.trim();
      if (name != null && name.isNotEmpty) {
        final parts = name.split(RegExp(r'\s+'));
        fn = parts.first;
        ln = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      }
    }
    return (fn, ln);
  }

  /// Strips a leading Saudi country code for display in the national number field.
  String _nationalPhoneDigits(String? phone) {
    final p = phone?.trim() ?? '';
    if (p.startsWith('+966')) return p.substring(4).trim();
    if (p.startsWith('966')) return p.substring(3).trim();
    return p;
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    return DateFormat('yyyy-MM-dd').format(value);
  }

  Future<void> _pickDateOfBirth(BuildContext context) async {
    final personalInfoCubit = context.read<PersonalInfoCubit>();
    final state = personalInfoCubit.state;
    final now = DateTime.now();
    final initialDate =
        state.dateOfBirth ?? widget.initialUser?.dateOfBirth ?? DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (!mounted || picked == null) return;
    personalInfoCubit.updateDateOfBirth(picked);
    _dobController.text = _formatDate(picked);
  }

  Future<void> _showProfilePictureOptions(BuildContext context) async {
    final cubit = context.read<PersonalInfoCubit>();
    final action = await showModalBottomSheet<ProfilePictureAction>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ProfilePictureBottomSheet(),
    );
    if (!mounted || action == null) return;

    switch (action) {
      case ProfilePictureAction.camera:
        await cubit.pickImageFromCamera();
        break;
      case ProfilePictureAction.gallery:
        await cubit.pickImageFromGallery();
        break;
      case ProfilePictureAction.remove:
        cubit.removeProfilePicture();
        break;
    }
  }

  Widget _buildProfileImage(PersonalInfoState state) {
    final selectedPath = state.selectedAvatarPath;
    final apiAvatar = resolveApiMediaUrl(widget.initialUser?.avatar);

    if (selectedPath != null && selectedPath.isNotEmpty) {
      return ClipOval(
        child: Image.file(
          File(selectedPath),
          height: 90,
          width: 90,
          fit: BoxFit.cover,
        ),
      );
    }

    if (!state.removeAvatar && apiAvatar != null && apiAvatar.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          apiAvatar,
          height: 90,
          width: 90,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            "assets/images/demo images/Trainer Avatar.png",
            height: 90,
            width: 90,
          ),
        ),
      );
    }

    return Image.asset(
      "assets/images/demo images/Trainer Avatar.png",
      height: 90,
      width: 90,
    );
  }

  void _submit(BuildContext context) {
    final phone = _phoneController.text.trim();
    context.read<PersonalInfoCubit>().saveProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: phone.isNotEmpty ? '+966$phone' : '',
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<PersonalInfoCubit, PersonalInfoState>(
      listenWhen: (prev, curr) => prev.saveStatus != curr.saveStatus,
      listener: (context, state) {
        if (state.saveStatus == PersonalInfoSaveStatus.success) {
          context.read<AuthCubit>().refreshProfileWhenSelectingAccountTab();
          Navigator.of(context).pop();
        } else if (state.saveStatus == PersonalInfoSaveStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage.isNotEmpty
                    ? state.errorMessage
                    : context.l10n.loginErrorGeneric,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.saveStatus == PersonalInfoSaveStatus.loading;
        return Scaffold(
          appBar: AppAppBar(
            onBack: () => Navigator.of(context).pop(),
            title: l10n.personalData,
            isMoreMenu: false,
          ),
          body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                buildWhen: (p, c) =>
                    p.selectedAvatarPath != c.selectedAvatarPath ||
                    p.removeAvatar != c.removeAvatar,
                builder: (context, picState) {
                  return GestureDetector(
                    onTap: () => _showProfilePictureOptions(context),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: _buildProfileImage(picState),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Center(
                          child: AppText(
                            l10n.changeProfilePicture,
                            style: (context) => AppTextStyles.body(
                              context,
                            ).copyWith(fontWeight: FontWeight.w400, height: 1.55),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: AppSpacing.lg),
              AppTextField(
                hint: context.l10n.firstName,
                label: context.l10n.firstName,
                controller: _firstNameController,
              ),
              SizedBox(height: AppSpacing.md),
              AppTextField(
                hint: context.l10n.lastName,
                label: context.l10n.lastName,
                controller: _lastNameController,
              ),
              SizedBox(height: AppSpacing.md),
              AppTextField(
                hint: context.l10n.recipientEmailHint,
                label: l10n.emailAddress,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              SizedBox(height: AppSpacing.md),
              PhoneNumberField(
                label: context.l10n.phoneNumber,
                countryCode: '+1',
                flagAsset: 'assets/flags/us.svg',
                controller: _phoneController,
              ),
              SizedBox(height: AppSpacing.md),
              BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                buildWhen: (p, c) => p.gender != c.gender,
                builder: (context, state) {
                  return AppDropDown<String>(
                    label: context.l10n.gender,
                    hint: context.l10n.selectGender,
                    value: state.gender,
                    items: [
                      DropdownMenuItem(
                        value: 'male',
                        child: Text(
                          context.l10n.male,
                          style: AppTextStyles.textField(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text(
                          context.l10n.female,
                          style: AppTextStyles.textField(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text(
                          context.l10n.other,
                          style: AppTextStyles.textField(context),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        context.read<PersonalInfoCubit>().updateGender(val);
                      }
                    },
                  );
                },
              ),
              SizedBox(height: AppSpacing.md),
              BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                buildWhen: (p, c) => p.dateOfBirth != c.dateOfBirth,
                builder: (context, state) {
                  _dobController.text = _formatDate(state.dateOfBirth);
                  return GestureDetector(
                    onTap: () => _pickDateOfBirth(context),
                    child: AbsorbPointer(
                      child: AppTextField(
                        hint: 'Select date of birth',
                        label: 'Date of Birth',
                        controller: _dobController,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: AppSpacing.lg),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.homeBackground : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.06),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: AppButton(
                  label: l10n.editDetails,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : () => _submit(context),
                  variant: AppButtonVariant.secondary,
                ),
              ),
              SizedBox(
                height: AppSpacing.xl,
              )
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}
