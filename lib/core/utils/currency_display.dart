const String _ltrIsolateStart = '\u2066';
const String _directionalIsolateEnd = '\u2069';

/// API amounts are **major** units. Omits meaningless fraction (`.00`). Trailing
/// fractional zeros are dropped (`799.50` → `799.5`); parses leading-zero strings
/// via [tryParseCurrencyAmount].
String formatPrice(num p) {
  if (p.isNaN || p.isInfinite) return '0';
  final cents = (p * 100).round();
  final whole = cents ~/ 100;
  final fracAbs = cents.abs() % 100;
  if (fracAbs == 0) return whole.toString();
  var frac = fracAbs.toString().padLeft(2, '0');
  frac = frac.replaceFirst(RegExp(r'0+$'), '');
  return '$whole.$frac';
}

bool isSaudiRiyalCode(String code) {
  return code.trim().toUpperCase() == 'SAR';
}

String currencySymbolForCode(String code) {
  if (isSaudiRiyalCode(code)) {
    return '\uFDFC';
  }
  return code.trim().toUpperCase();
}

/// Strips grouping commas, leading zeros on the integer part (`0089.50` → `89.50`),
/// and parses as [num]. Leaves scientific notation unchanged.
String _normalizeParsableAmountString(String raw) {
  var t = raw.trim().replaceAll(',', '');
  if (t.isEmpty) return t;
  if (RegExp(r'[eE]').hasMatch(t)) return t;

  var negative = false;
  if (t.startsWith('-')) {
    negative = true;
    t = t.substring(1).trim();
  } else if (t.startsWith('+')) {
    t = t.substring(1).trim();
  }
  if (t.isEmpty) return negative ? '-' : '';

  final dot = t.indexOf('.');
  late String intPart;
  final String rest;
  if (dot >= 0) {
    intPart = t.substring(0, dot);
    rest = t.substring(dot);
  } else {
    intPart = t;
    rest = '';
  }

  intPart = intPart.replaceFirst(RegExp(r'^0+'), '');
  if (intPart.isEmpty) intPart = '0';

  final body = '$intPart$rest';
  return negative ? '-$body' : body;
}

num? tryParseCurrencyAmount(Object? rawAmount) {
  if (rawAmount == null) return null;
  if (rawAmount is num) return rawAmount;
  final text = rawAmount.toString().trim().replaceAll(',', '');
  if (text.isEmpty) return null;
  if (RegExp(r'[eE]').hasMatch(text)) {
    return num.tryParse(text);
  }
  return num.tryParse(_normalizeParsableAmountString(text));
}

String formatCurrencyNumber(num amount, {int decimals = 2}) {
  if (decimals <= 0) return amount.round().toString();
  if (decimals == 2) return formatPrice(amount);
  final formatted = amount.toStringAsFixed(decimals);
  return formatted
      .replaceFirst(RegExp(r'0*$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

String formatCurrencyAmount({
  required num amount,
  required String code,
  int decimals = 2,
}) {
  return formatCurrencyAmountLeading(
    amount: amount,
    code: code,
    decimals: decimals,
  );
}

/// Symbol then amount in LTR order — for embedding in RTL sentences (buttons, l10n).
String formatCurrencyAmountLeading({
  required num amount,
  required String code,
  int decimals = 2,
}) {
  final symbol = currencySymbolForCode(code);
  final formattedNumber = isSaudiRiyalCode(code)
      ? formatPrice(amount)
      : formatCurrencyNumber(amount, decimals: decimals);
  // LRI + LRM keeps "﷼ 90" left-to-right inside Arabic copy.
  const lrm = '\u200E';
  final formatted = '$lrm$symbol\u00A0$formattedNumber';
  return '$_ltrIsolateStart$formatted$_directionalIsolateEnd';
}

String formatCurrencyAmountCompact({
  required num amount,
  required String code,
}) {
  if (isSaudiRiyalCode(code)) {
    return formatCurrencyAmount(amount: amount, code: code);
  }
  final decimals = amount == amount.roundToDouble() ? 0 : 2;
  return formatCurrencyAmount(amount: amount, code: code, decimals: decimals);
}

String formatCurrencyAmountFromRaw({
  required Object? amount,
  required String code,
  int decimals = 2,
}) {
  final parsed = tryParseCurrencyAmount(amount);
  if (parsed == null) return '—';
  return formatCurrencyAmount(amount: parsed, code: code, decimals: decimals);
}
