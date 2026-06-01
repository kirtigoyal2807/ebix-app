import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/utils/date_of_birth_constraints.dart';
import 'package:pilates_app/core/utils/show_date_of_birth_picker.dart';
import 'package:pilates_app/core/utils/api_media_url.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dropdown.dart';
import '../../../widgets/phone_number_field.dart';
import '../../auth/widgets/phone_otp_view.dart';
import '../../auth/widgets/profile_email_verification_view.dart';
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
  bool _isEditing = false;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;
  late String _phoneCountryIso;
  CountryCode? _phoneCountry;

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final names = _namesFromUser(widget.initialUser);
    final profilePhone = _parseProfilePhone(widget.initialUser?.phone);
    _phoneCountryIso = profilePhone.iso3166;
    _phoneCountry =
        CountryCode.tryFromCountryCode(_phoneCountryIso) ??
        CountryCode.tryFromCountryCode('AE');
    _firstNameController = TextEditingController(text: names.$1);
    _lastNameController = TextEditingController(text: names.$2);
    _emailController = TextEditingController(
      text: widget.initialUser?.email?.trim() ?? '',
    );
    _phoneController = TextEditingController(text: profilePhone.nationalDigits);
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
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
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

  /// Parses API [phone] (E.164, e.g. `+917014675174`) into national digits and ISO country.
  ({String nationalDigits, String iso3166}) _parseProfilePhone(String? phone) {
    final raw = phone?.trim() ?? '';
    if (raw.isEmpty) {
      return (nationalDigits: '', iso3166: 'AE');
    }
    try {
      final withPlus = raw.startsWith('+') ? raw : '+$raw';
      final parsed = PhoneNumber.parse(withPlus);
      return (nationalDigits: parsed.nsn, iso3166: parsed.isoCode.name);
    } catch (_) {
      if (raw.startsWith('+966')) {
        return (nationalDigits: raw.substring(4).trim(), iso3166: 'SA');
      }
      if (raw.startsWith('966')) {
        return (nationalDigits: raw.substring(3).trim(), iso3166: 'SA');
      }
      final digits = raw.replaceAll(RegExp(r'\D'), '');
      return (nationalDigits: digits, iso3166: 'AE');
    }
  }

  String _composePhoneE164() {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    final dial =
        _phoneCountry?.dialCode ??
        CountryCode.tryFromCountryCode(_phoneCountryIso)?.dialCode ??
        '+971';
    final cleanDial = dial.startsWith('+') ? dial : '+$dial';
    return '$cleanDial$digits';
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    return DateFormat('dd/MM/yyyy').format(value);
  }

  /// Only [female] exists in the menu (product rule). API may still return
  /// `male` / `other`; passing those as [DropdownButtonFormField.value] asserts.
  /// Returns a value that matches an item, or null (hint) while [PersonalInfoCubit]
  /// keeps the real API gender until the user selects Female.
  String? _genderDropdownValue(String? storedGender) {
    final g = storedGender?.trim().toLowerCase();
    return g == 'female' ? 'female' : null;
  }

  Future<void> _pickDateOfBirth(BuildContext context) async {
    final personalInfoCubit = context.read<PersonalInfoCubit>();
    final state = personalInfoCubit.state;
    final today = DateTime.now();
    final firstDate = DateTime(1900);
    final lastDob = DateOfBirthConstraints.latestSelectableBirthDate(today);
    final baseInitial =
        state.dateOfBirth ?? widget.initialUser?.dateOfBirth ?? lastDob;
    final initialDate = DateOfBirthConstraints.clampToSelectableRange(
      baseInitial,
      firstDate,
      lastDob,
    );
    final picked = await showDateOfBirthPicker(
      context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDob,
    );
    if (!mounted || picked == null) return;
    personalInfoCubit.updateDateOfBirth(picked);
    _dobController.text = _formatDate(picked);
  }

  Future<void> _showProfilePictureOptions(BuildContext context) async {
    final cubit = context.read<PersonalInfoCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final action = await showModalBottomSheet<ProfilePictureAction>(
      context: context,
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
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
    final cubitState = context.read<PersonalInfoCubit>().state;
    final dob = cubitState.dateOfBirth;
    if (dob != null &&
        !DateOfBirthConstraints.satisfiesMinimumAge(dob, DateTime.now())) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.dobMinimumAgeError)));
      return;
    }
    final phone = _composePhoneE164();
    context.read<PersonalInfoCubit>().saveProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: phone,
      phoneNationalRaw: _phoneController.text,
      phoneCountryIso3166: _phoneCountry?.code ?? _phoneCountryIso,
      l10n: context.l10n,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<PersonalInfoCubit, PersonalInfoState>(
      listenWhen: (prev, curr) => prev.saveStatus != curr.saveStatus,
      listener: (context, state) async {
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
        } else if (state.saveStatus ==
            PersonalInfoSaveStatus.emailVerificationRequired) {
          final personalInfoCubit = context.read<PersonalInfoCubit>();
          final verified = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: personalInfoCubit,
                child: ProfileEmailVerificationView(
                  email: state.pendingEmail ?? '',
                ),
              ),
            ),
          );

          if (!context.mounted) return;
          context.read<PersonalInfoCubit>().resetStatus();

          if (verified == true && context.mounted) {
            context.read<AuthCubit>().refreshProfileWhenSelectingAccountTab();
            Navigator.of(context).pop();
          }
        } else if (state.saveStatus ==
            PersonalInfoSaveStatus.phoneVerificationRequired) {
          final personalInfoCubit = context.read<PersonalInfoCubit>();
          final verified = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: personalInfoCubit,
                child: PhoneOtpView(
                  phone: state.pendingPhoneNumber ?? '',
                  title: context.l10n.verifyPhone,
                  subtitlePrefix: context.l10n.enterCode,
                ),
              ),
            ),
          );

          if (!context.mounted) return;
          // Reset cubit status
          context.read<PersonalInfoCubit>().resetStatus();

          // If OTP verified successfully, close PersonalView
          if (verified == true && context.mounted) {
            context.read<AuthCubit>().refreshProfileWhenSelectingAccountTab();
            Navigator.of(context).pop();
          }
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
          body: Stack(
            children: [
              SingleChildScrollView(
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
                            onTap: _isEditing
                                ? () => _showProfilePictureOptions(context)
                                : null,
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
                                    style: (context) =>
                                        AppTextStyles.body(context).copyWith(
                                          fontWeight: FontWeight.w400,
                                          height: 1.55,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.lg),
                      IgnorePointer(
                        ignoring: !_isEditing,
                        child: AppTextField(
                          hint: context.l10n.firstName,
                          label: context.l10n.firstName,
                          controller: _firstNameController,
                          focusNode: _firstNameFocus,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(
                            context,
                          ).requestFocus(_lastNameFocus),
                          readOnly: !_isEditing,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      IgnorePointer(
                        ignoring: !_isEditing,
                        child: AppTextField(
                          hint: context.l10n.lastName,
                          label: context.l10n.lastName,
                          controller: _lastNameController,
                          focusNode: _lastNameFocus,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          readOnly: !_isEditing,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      // TEMP: email not editable in edit mode — remove when re-enabling.
                      IgnorePointer(
                        child: AppTextField(
                          hint: context.l10n.recipientEmailHint,
                          label: l10n.emailAddress,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          focusNode: _emailFocus,
                          readOnly: true,
                          enabled: false,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      // TEMP: phone + country code not editable in edit mode — remove when re-enabling.
                      IgnorePointer(
                        child: PhoneNumberField(
                          key: ValueKey<String?>(
                            'personal_phone_${widget.initialUser?.phone ?? ''}',
                          ),
                          label: context.l10n.phoneNumber,
                          countryCode: '+1',
                          flagAsset: 'assets/flags/us.svg',
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          enabled: false,
                          initialCountryIso: _phoneCountryIso,
                          onCountryChanged: (country) {
                            setState(() {
                              _phoneCountry = country;
                              _phoneCountryIso =
                                  country.code ?? _phoneCountryIso;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                        buildWhen: (p, c) => p.gender != c.gender,
                        builder: (context, state) {
                          return AppDropDown<String>(
                            label: context.l10n.gender,
                            hint: context.l10n.selectGender,
                            value: _genderDropdownValue(state.gender),
                            items: [
                              DropdownMenuItem(
                                value: 'female',
                                child: Text(
                                  context.l10n.female,
                                  style: AppTextStyles.textField(context),
                                ),
                              ),
                            ],
                            onChanged: _isEditing
                                ? (val) {
                                    if (val != null) {
                                      context
                                          .read<PersonalInfoCubit>()
                                          .updateGender(val);
                                    }
                                  }
                                : null,
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.md),
                      BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                        buildWhen: (p, c) => p.dateOfBirth != c.dateOfBirth,
                        builder: (context, state) {
                          _dobController.text = _formatDate(state.dateOfBirth);
                          return IgnorePointer(
                            ignoring: !_isEditing,
                            child: GestureDetector(
                              onTap: () => _pickDateOfBirth(context),
                              child: AbsorbPointer(
                                child: AppTextField(
                                  hint: context.l10n.selectDOB,
                                  label: context.l10n.date_of_birth,
                                  controller: _dobController,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.xxxl * 2),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: AppSpacing.md + 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: isDark
                          ? [
                              AppColors.darkShadow,
                              AppColors.darkShadow.withValues(alpha: 0),
                            ]
                          : [Colors.white, Colors.white.withValues(alpha: 0)],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: AppSpacing.md,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: AppButton(
                    label: _isEditing ? l10n.updateProfile : l10n.editDetails,
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_isEditing) {
                              _submit(context);
                            } else {
                              setState(() => _isEditing = true);
                            }
                          },
                    variant: AppButtonVariant.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
