import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/core/utils/currency_display.dart';

/// Shared SAR formatting: SVG riyal symbol + amount (same as subscription [PlanCard]).
///
/// Non-SAR currencies use [formatCurrencyAmount] as plain text.
class CurrencyAmountText extends StatelessWidget {
  const CurrencyAmountText({
    super.key,
    required this.amount,
    required this.currencyCode,
    required this.style,
    this.colorLight,
    this.colorDark,
    this.priceSuffix = '',
    this.iconRightPadding = 6,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
    this.leading = '',
  });

  final num? amount;
  final String currencyCode;
  final TextStyle Function(BuildContext) style;
  /// When set, applied in light mode (overrides [style] color).
  final Color? colorLight;
  /// When set, applied in dark mode (overrides [style] color).
  final Color? colorDark;
  final String priceSuffix;
  final double iconRightPadding;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  /// Shown before the amount (e.g. `- ` for discounts).
  final String leading;

  TextStyle _resolvedStyle(BuildContext context) {
    final base = style(context);
    if (colorLight == null && colorDark == null) return base;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? (colorDark ?? colorLight) : (colorLight ?? colorDark);
    return color != null ? base.copyWith(color: color) : base;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = _resolvedStyle(context);
    if (amount == null) {
      return Text(
        '${leading}—',
        style: textStyle,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }

    if (!isSaudiRiyalCode(currencyCode)) {
      final formattedPrice = formatCurrencyAmount(
        amount: amount!,
        code: currencyCode,
      );
      final priceLine = [
        if (leading.isNotEmpty) leading,
        formattedPrice,
        priceSuffix,
      ].join();
      return Text(
        priceLine,
        style: textStyle,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }

    final fontSize = textStyle.fontSize ?? 14;
    final iconHeight = fontSize * 0.95;
    final iconWidth = iconHeight * 14 / 16;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text.rich(
        TextSpan(
          style: textStyle,
          children: [
            if (leading.isNotEmpty) TextSpan(text: leading),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _saudiRiyalSymbol(
                iconHeight: iconHeight,
                iconWidth: iconWidth,
                iconRightPadding: iconRightPadding,
                color: textStyle.color,
              ),
            ),
            TextSpan(text: '${formatPrice(amount!)}$priceSuffix'),
          ],
        ),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      ),
    );
  }
}

Widget _saudiRiyalSymbol({
  required double iconHeight,
  required double iconWidth,
  required double iconRightPadding,
  Color? color,
}) {
  return Padding(
    padding: EdgeInsets.only(right: iconRightPadding),
    child: SvgPicture.asset(
      'assets/images/svg/ic_Saudi_Riyal_Symbol.svg',
      height: iconHeight,
      width: iconWidth,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    ),
  );
}

/// Inline spans for embedding a formatted amount inside a larger [Text.rich].
List<InlineSpan> currencyAmountInlineSpans({
  required num? amount,
  required String currencyCode,
  required TextStyle textStyle,
  String priceSuffix = '',
  double iconRightPadding = 6,
  String leading = '',
}) {
  if (amount == null) {
    return [TextSpan(text: '${leading}—', style: textStyle)];
  }
  if (!isSaudiRiyalCode(currencyCode)) {
    final formatted = formatCurrencyAmount(amount: amount!, code: currencyCode);
    final line = [
      if (leading.isNotEmpty) leading,
      formatted,
      priceSuffix,
    ].join();
    return [TextSpan(text: line, style: textStyle)];
  }

  final fontSize = textStyle.fontSize ?? 14;
  final iconHeight = fontSize * 0.95;
  final iconWidth = iconHeight * 14 / 16;
  return [
    if (leading.isNotEmpty) TextSpan(text: leading, style: textStyle),
    WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: _saudiRiyalSymbol(
        iconHeight: iconHeight,
        iconWidth: iconWidth,
        iconRightPadding: iconRightPadding,
        color: textStyle.color,
      ),
    ),
    TextSpan(
      text: '${formatPrice(amount!)}$priceSuffix',
      style: textStyle,
    ),
  ];
}
