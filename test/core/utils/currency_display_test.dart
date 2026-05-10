import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/utils/currency_display.dart';

void main() {
  group('currency display', () {
    test('uses the Saudi Riyal symbol for SAR', () {
      expect(currencySymbolForCode('SAR'), '\u20C1');
      expect(currencySymbolForCode('sar'), '\u20C1');
    });

    test('formats SAR with two decimals and a fixed symbol-first order', () {
      expect(
        formatCurrencyAmount(amount: 100, code: 'SAR'),
        '\u2066\u20C1 100.00\u2069',
      );
    });

    test('formats raw numeric values with the shared currency pattern', () {
      expect(
        formatCurrencyAmountFromRaw(amount: '9.5', code: 'SAR'),
        '\u2066\u20C1 9.50\u2069',
      );
    });
  });
}
