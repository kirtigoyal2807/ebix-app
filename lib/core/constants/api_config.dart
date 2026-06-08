/// Production API base (trailing slash). Hopscotch examples for checkout:
/// - `POST {base}checkout/start`
/// - `POST {base}checkout/<uuid>/gift` (when `isGift` is true)
/// - `GET {base}branches` (studios list; optional `page`, `per_page`, geo query params)
/// - `GET {base}checkout/<uuid>`
/// - `GET {base}health-intake/questionnaires/product/<productId>` (by product)
/// - `GET {base}health-intake/questionnaires/<questionnaireId>` (single form)
/// - `POST {base}checkout/<uuid>/health-intake` (questionnaire payload)
/// - `POST {base}checkout/<uuid>/apply-coupon` body `{"code":"…"}`
/// - `POST {base}checkout/<uuid>/payment/intent`
/// `X-Brand` and `Accept-Language`, optional `Authorization: Bearer <JWT>`.
abstract final class ApiConfig {
  /// Must end with `/`. Request paths must be **relative** (no leading `/`),
  /// otherwise Dio resolves them from the domain root and **drops** `/api/v1/`.
  static const String baseUrl = 'https://admin.thepilates.sa/api/v1/';

  /// Sent as [headerBrand] (e.g. `pilates`).
  static const String brand = 'pilates';

  static const String headerBrand = 'X-Brand';
  static const String headerAcceptLanguage = 'Accept-Language';
  static const String headerAuthorization = 'Authorization';

  /// Optional checkout UUID for **gift recipient** testing when the app navigation
  /// did not pass a session id yet (no `GiftSubscriptionView(checkoutId:)` / route args).
  ///
  /// ```
  /// flutter run --dart-define=GIFT_CHECKOUT_ID=019c70d5-d634-705a-a3f4-6e64c060cad1
  /// ```
  static String? get debugGiftCheckoutSessionId {
    const v = String.fromEnvironment('GIFT_CHECKOUT_ID', defaultValue: '');
    final t = v.trim();
    return t.isEmpty ? null : t;
  }
}
