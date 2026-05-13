import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/validation/phone_number_country_validation.dart';

import 'app_text.dart';

/// ITU-style cap for national significant digits (`phone_numbers_parser` uses up to 17).
const int _kMaxNationalSignificantDigits = 17;

/// Same as [Constants.minLengthNsn] in `phone_numbers_parser` — avoid inline errors while the user has typed fewer digits.
const int _kMinNationalSignificantDigitsForValidation = 3;

/// Longest NSN length allowed for mobile or fixed-line subscriber numbers for [iso]
/// (avoids toll-free / premium-only lengths so e.g. India caps at 10, not 13).
int _maxSubscriberNationalDigits(IsoCode iso) {
  var maxFound = 0;
  for (var len = 1; len <= _kMaxNationalSignificantDigits; len++) {
    final p = PhoneNumber(isoCode: iso, nsn: '5' * len);
    if (p.isValidLength(type: PhoneNumberType.mobile) ||
        p.isValidLength(type: PhoneNumberType.fixedLine)) {
      if (len > maxFound) maxFound = len;
    }
  }
  if (maxFound > 0) return maxFound;
  for (var len = 1; len <= _kMaxNationalSignificantDigits; len++) {
    final p = PhoneNumber(isoCode: iso, nsn: '5' * len);
    if (p.isValidLength()) {
      if (len > maxFound) maxFound = len;
    }
  }
  return maxFound > 0 ? maxFound : _kMaxNationalSignificantDigits;
}

class PhoneNumberField extends StatefulWidget {
  final String label;
  final String countryCode;
  final String flagAsset;
  final TextEditingController? controller;
  final String? errorText;
  final Function(CountryCode)? onCountryChanged;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  /// Optional stricter cap (e.g. 10). The effective limit is the minimum of this value,
  /// per-country metadata (subscriber lengths), and [_kMaxNationalSignificantDigits].
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
    this.initialCountryIso = 'SA',
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
    return PhoneNumberCountryValidation.isValidNationalNumber(
      iso3166Alpha2: iso3166Alpha2,
      nationalDigitsOnly: nationalDigitsOnly,
    );
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

  int _effectiveMaxNationalDigits() {
    final iso = PhoneNumberField._tryIso(_selectedCountryCode?.code ?? '');
    if (iso == null) return _kMaxNationalSignificantDigits;
    var cap = math.min(
      _maxSubscriberNationalDigits(iso),
      _kMaxNationalSignificantDigits,
    );
    // Allow optional single leading zero (trunk prefix) for all countries.
    // Example: 09876543210 (11 digits) -> normalized to 9876543210 (10 digits).
    cap = math.min(cap + 1, _kMaxNationalSignificantDigits);
    if (widget.maxPhoneDigits != null) {
      cap = math.min(cap, widget.maxPhoneDigits!);
    }
    return cap;
  }

  String? _countryValidationMessage(BuildContext context) {
    final isoCode = (_selectedCountryCode?.code ?? '').trim().toUpperCase();
    if (PhoneNumberField._tryIso(isoCode) == null) return null;
    final digits = (widget.controller?.text ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;
    if (digits.length < _kMinNationalSignificantDigitsForValidation) {
      return null;
    }
    if (PhoneNumberField.isNationalNumberValid(
      iso3166Alpha2: isoCode,
      nationalDigitsOnly: digits,
    )) {
      return null;
    }
    return context.l10n.invalidPhoneForCountry;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final maxDigits = _effectiveMaxNationalDigits();
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
                IgnorePointer(
                  ignoring: !widget.enabled,
                  child: CountryCodePicker(
                  pickerStyle: PickerStyle.bottomSheet,
                  favorite: const ['SA'],
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
                      LengthLimitingTextInputFormatter(maxDigits),
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
