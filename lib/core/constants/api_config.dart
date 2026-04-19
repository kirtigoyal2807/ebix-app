/// Pilates API environment (dev). Swap for staging/production when you add flavors.
///
/// Contract: `application/json`, standard envelope, required headers
/// `X-Brand` and `Accept-Language`, optional `Authorization: Bearer <JWT>`.
abstract final class ApiConfig {
  static const String baseUrl = 'https://dev.thepilates.sa/api/v1/';

  /// Sent as [headerBrand] (e.g. `pilates`).
  static const String brand = 'pilates';

  static const String headerBrand = 'X-Brand';
  static const String headerAcceptLanguage = 'Accept-Language';
  static const String headerAuthorization = 'Authorization';
}
