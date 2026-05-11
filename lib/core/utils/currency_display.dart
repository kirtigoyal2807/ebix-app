const String _ltrIsolateStart = '\u2066';
const String _directionalIsolateEnd = '\u2069';

bool isSaudiRiyalCode(String code) {
  return code.trim().toUpperCase() == 'SAR';
}

String currencySymbolForCode(String code) {
  if (isSaudiRiyalCode(code)) {
    return 'SAR';
  }
  return code.trim().toUpperCase();
}

num? tryParseCurrencyAmount(Object? rawAmount) {
  if (rawAmount == null) return null;
  if (rawAmount is num) return rawAmount;
  final text = rawAmount.toString().trim();
  if (text.isEmpty) return null;
  return num.tryParse(text.replaceAll(',', ''));
}

String formatCurrencyAmount({
  required num amount,
  required String code,
  int decimals = 2,
}) {
  final symbol = currencySymbolForCode(code);
  final formatted = '$symbol ${amount.toStringAsFixed(decimals)}';
  return '$_ltrIsolateStart$formatted$_directionalIsolateEnd';
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
