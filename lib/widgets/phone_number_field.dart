import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import 'app_text.dart';

/// ITU-style cap for national significant digits (`phone_numbers_parser` uses up to 17).
const int _kMaxNationalSignificantDigits = 17;

class PhoneNumberField extends StatefulWidget {
  final String label;
  final String countryCode;
  final String flagAsset;
  final TextEditingController? controller;
  final String? errorText;
  final Function(CountryCode)? onCountryChanged;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  /// Legacy cap; ignored in favor of per-country validation and [_kMaxNationalSignificantDigits].
  final int? maxPhoneDigits;

  /// ISO 3166-1 alpha-2 for [CountryCodePicker.initialSelection].
  final String initialCountryIso;

  /// When null, an internal node is created and disposed by this widget.
  final FocusNode? focusNode;

  final TextInputAction textInputAction;

  final ValueChanged<String>? onFieldSubmitted;

  const PhoneNumberField({
    super.key,
    required this.label,
    required this.countryCode,
    required this.flagAsset,
    this.controller,
    this.errorText,
    this.onCountryChanged,
    this.onChanged,
    this.maxPhoneDigits,
    this.initialCountryIso = 'AE',
    this.enabled = true,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  /// Validates [nationalDigitsOnly] (no country code) for [iso3166Alpha2] (e.g. `AE`, `SA`).
  static bool isNationalNumberValid({
    required String iso3166Alpha2,
    required String nationalDigitsOnly,
  }) {
    final iso = _tryIso(iso3166Alpha2);
    if (iso == null) return false;
    final digits = nationalDigitsOnly.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return false;
    try {
      final parsed = PhoneNumber.parse(digits, callerCountry: iso);
      return parsed.isValid();
    } catch (_) {
      return false;
    }
  }

  static IsoCode? _tryIso(String iso3166Alpha2) {
    final upper = iso3166Alpha2.trim().toUpperCase();
    if (upper.length != 2) return null;
    try {
      return IsoCode.fromJson(upper);
    } catch (_) {
      return null;
    }
  }

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;
  bool _isFocused = false;
  CountryCode? _selectedCountryCode;
  bool _initialCountryNotifiedParent = false;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    widget.controller?.addListener(_onPhoneDigitsChanged);

    final code = widget.initialCountryIso.trim().toUpperCase();
    if (code.length == 2) {
      _selectedCountryCode = CountryCode.tryFromCountryCode(code);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialCountryNotifiedParent) return;
    _initialCountryNotifiedParent = true;
    final raw = CountryCode.tryFromCountryCode(widget.initialCountryIso.trim().toUpperCase());
    if (raw != null) {
      final localized = raw.localize(context);
      setState(() => _selectedCountryCode = localized);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.onCountryChanged?.call(localized);
      });
    }
  }

  @override
  void didUpdateWidget(covariant PhoneNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onPhoneDigitsChanged);
      widget.controller?.addListener(_onPhoneDigitsChanged);
    }
  }

  void _onPhoneDigitsChanged() {
    setState(() {});
  }

  void _onCountryChanged(CountryCode country) {
    setState(() {
      _selectedCountryCode = country;
    });
    widget.onCountryChanged?.call(country);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onPhoneDigitsChanged);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  String? _countryValidationMessage(BuildContext context) {
    final iso = PhoneNumberField._tryIso(_selectedCountryCode?.code ?? '');
    if (iso == null) return null;
    final digits = (widget.controller?.text ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;
    try {
      final parsed = PhoneNumber.parse(digits, callerCountry: iso);
      if (parsed.isValid()) return null;
      if (!parsed.isValidLength()) return null;
      return context.l10n.invalidPhoneForCountry;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final countryMessage = _countryValidationMessage(context);
    final displayError = widget.errorText ?? countryMessage;
    final hasError = displayError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(widget.label, style: AppTextStyles.textFieldHeading),

        SizedBox(height: AppSpacing.sm),

        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: hasError
                    ? (isDark ? AppColors.redDark : AppColors.redLight)
                    : (_isFocused
                          ? theme.colorScheme.primary
                          : theme.dividerColor),
                width: _isFocused ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                CountryCodePicker(
                  pickerStyle: PickerStyle.bottomSheet,
                  favorite: const ['AE'],
                  headerText: context.l10n.selectCountry,
                  onChanged: widget.enabled
                      ? (CountryCode countryCode) => _onCountryChanged(countryCode)
                      : null,
                  initialSelection: widget.initialCountryIso,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  boxDecoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.md),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  searchDecoration: InputDecoration(
                    hintText: context.l10n.searchCountry,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  textStyle: theme.textTheme.bodyMedium,
                  flagWidth: 24,
                  backgroundColor: theme.colorScheme.surface,
                  barrierColor: Colors.black54,
                  dialogBackgroundColor: theme.colorScheme.surface,
                ),

                Container(width: 1, height: 24, color: theme.dividerColor),

                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    textInputAction: widget.textInputAction,
                    onSubmitted: widget.onFieldSubmitted,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                        _kMaxNationalSignificantDigits,
                      ),
                    ],
                    onChanged: widget.onChanged,
                    style: AppTextStyles.textField(context),
                    decoration: InputDecoration(
                      hintText: context.l10n.phoneHint,
                      hintStyle: AppTextStyles.textField(
                        context,
                      ).copyWith(color: AppColors.lightGrey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: isDark ? AppColors.redDark : AppColors.redLight,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  displayError,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.redDark : AppColors.redLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
