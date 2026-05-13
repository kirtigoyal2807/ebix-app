/// Rules for government ID on emergency-contact / checkout (`idType` + `idNumber`).
abstract final class IdDocumentValidators {
  IdDocumentValidators._();

  /// UI dropdown values from [RequiredInformationView] (`National ID`, etc.).
  static bool isValidForUiIdType(String? uiIdType, String raw) {
    final t = uiIdType?.trim();
    final s = raw.trim();
    if (s.isEmpty) return false;
    switch (t) {
      case 'National ID':
        return _isValidNationalIdentityDigits(raw);
      case 'Iqama':
        return _isValidIqamaDigits(raw);
      case 'Passport':
        return isValidPassportNumber(s);
      case 'Driver License':
        return isValidDriverLicenseNumber(s);
      default:
        return s.isNotEmpty && s.length <= 100;
    }
  }

  /// Saudi National ID — 10 digits, starts with **1**, government checksum algorithm.
  static bool _isValidNationalIdentityDigits(String raw) {
    final d = _digitsOnlyTen(raw);
    if (d == null || d[0] != '1') return false;
    return saudiGovernmentIdChecksumValid(d);
  }

  /// Iqama — same checksum; must start with **2**.
  static bool _isValidIqamaDigits(String raw) {
    final d = _digitsOnlyTen(raw);
    if (d == null || d[0] != '2') return false;
    return saudiGovernmentIdChecksumValid(d);
  }

  static String? _digitsOnlyTen(String raw) {
    final d = raw.replaceAll(RegExp(r'\D'), '');
    if (d.length != 10 || int.tryParse(d) == null) return null;
    return d;
  }

  /// 10-digit KSA NIC / Iqama validation (digits only). Even indices doubled.
  static bool saudiGovernmentIdChecksumValid(String tenDigits) {
    if (!RegExp(r'^[12]\d{9}$').hasMatch(tenDigits)) return false;
    var sum = 0;
    for (var i = 0; i < 10; i++) {
      final n = tenDigits.codeUnitAt(i) - 48;
      if (n < 0 || n > 9) return false;
      if (i.isEven) {
        final doubled = n * 2;
        sum += doubled < 10 ? doubled : doubled ~/ 10 + doubled % 10;
      } else {
        sum += n;
      }
    }
    return sum % 10 == 0;
  }

  /// Prefer [National ID] or [Iqama] validators in UI; kept for callers that still
  /// accept either in one field.
  static bool isValidSaudiNationalIdOrIqamaDigits(String raw) {
    final d = _digitsOnlyTen(raw);
    if (d == null) return false;
    return saudiGovernmentIdChecksumValid(d);
  }

  static bool isValidPassportNumber(String raw) {
    final compact = raw.replaceAll(RegExp(r'\s'), '');
    if (compact.length < 6 || compact.length > 20) return false;
    return RegExp(r'^[A-Za-z0-9]+$').hasMatch(compact);
  }

  static bool isValidDriverLicenseNumber(String raw) {
    final compact = raw.replaceAll(RegExp(r'\s'), '');
    if (compact.length < 4 || compact.length > 24) return false;
    return RegExp(r'^[A-Za-z0-9]+$').hasMatch(compact);
  }
}
