/// Response from `POST checkout/{checkoutId}/payment/intent` (client “payment link”).
class CheckoutPaymentIntentResult {
  const CheckoutPaymentIntentResult({
    this.clientSecret,
    this.paymentUrl,
    this.intentId,
    this.paymentId,
    this.publishableKey,
    this.raw,
    this.alreadyCompleted = false,
  });

  final String? clientSecret;
  final String? paymentUrl;
  final String? intentId;

  /// PSP row id when the API returns `paymentId` (e.g. Paytabs).
  final String? paymentId;
  final String? publishableKey;

  /// Unparsed payload for gateways not covered above.
  final Map<String, dynamic>? raw;

  /// Set when the API reports this checkout is already paid (no new intent/link).
  final bool alreadyCompleted;

  factory CheckoutPaymentIntentResult.fromJson(dynamic json) {
    if (json is! Map) {
      return const CheckoutPaymentIntentResult();
    }
    final m = Map<String, dynamic>.from(json);
    return CheckoutPaymentIntentResult(
      alreadyCompleted: false,
      clientSecret: _readString(m, const [
        'clientSecret',
        'client_secret',
        'paymentIntentClientSecret',
      ]),
      paymentUrl: _readString(m, const [
        'paymentUrl',
        'payment_url',
        'url',
        'checkoutUrl',
        'hostedPageUrl',
      ]),
      intentId: _readString(m, const [
        'intentId',
        'intent_id',
        'paymentIntentId',
        'payment_intent_id',
        'id',
      ]),
      paymentId: _readString(m, const ['paymentId', 'payment_id']),
      publishableKey: _readString(m, const [
        'publishableKey',
        'publishable_key',
      ]),
      raw: m,
    );
  }

  static String? _readString(Map<String, dynamic> m, List<String> keys) {
    for (final k in keys) {
      final v = m[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
      if (v != null) {
        final s = v.toString().trim();
        if (s.isNotEmpty) return s;
      }
    }
    return null;
  }
}
