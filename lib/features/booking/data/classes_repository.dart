import 'package:dio/dio.dart';
import 'package:pilates_app/core/network/api_envelope.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/booking/data/models/class_event_detail.dart';
import 'package:pilates_app/features/booking/data/models/gym_class_resource.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';

/// Pilates API — Classes & Bookings module (§13.2 – §13.9).
class ClassesRepository extends BaseRepository {
  ClassesRepository(super.dio);

  // ---------------------------------------------------------------------------
  // §13.2  List All Class Types
  // ---------------------------------------------------------------------------

  /// Returns all active class types, each with `upcomingEvents` for the next
  /// 30 days. Pass [search] to filter server-side by name.
  Future<ApiResult<List<GymClassResource>>> listClasses({
    String? search,
  }) async {
    try {
      final response = await httpClient.get<dynamic>(
        '/classes',
        queryParameters: {
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
        },
      );

      final code = response.statusCode;
      if (code == null) {
        return ApiFailure(
          NetworkException(
            type: NetworkFailureType.badResponse,
            message: 'Missing status code',
            responseData: response.data,
          ),
        );
      }
      if (code < 200 || code >= 300) {
        return ApiFailure(
          NetworkException(
            type: NetworkFailureType.badResponse,
            message: 'HTTP $code',
            statusCode: code,
            responseData: response.data,
          ),
        );
      }

      final raw = response.data;
      final envelope = ApiEnvelopeParser.tryParse(raw);
      if (envelope != null) {
        if (!envelope.success) {
          return ApiFailure(
            NetworkException.fromApiEnvelope(
              statusCode: code,
              message:
                  envelope.message.isEmpty
                      ? 'Request failed'
                      : envelope.message,
              fieldErrors: envelope.fieldErrors,
              responseData: raw,
            ),
          );
        }
        return ApiSuccess(
          _parseClassList(envelope.data),
          statusCode: code,
        );
      }
      return ApiSuccess(_parseClassList(raw), statusCode: code);
    } on DioException catch (e, st) {
      return ApiFailure(NetworkException.fromDioException(e, st));
    } catch (e, st) {
      return ApiFailure(NetworkException.fromUnknown(e, st));
    }
  }

  static List<GymClassResource> _parseClassList(dynamic payload) {
    final list = payload is List ? payload : (payload is Map ? payload['data'] ?? [] : []);
    final out = <GymClassResource>[];
    if (list is List) {
      for (final e in list) {
        if (e is Map<String, dynamic>) {
          out.add(GymClassResource.fromJson(e));
        } else if (e is Map) {
          out.add(GymClassResource.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return out;
  }

  // ---------------------------------------------------------------------------
  // §13.3  Class Type Detail
  // ---------------------------------------------------------------------------

  /// Returns a single class template with its upcoming events + reviews.
  Future<ApiResult<GymClassResource>> getClassDetail(String classId) {
    final id = classId.trim();
    return get<GymClassResource>(
      '/classes/$id',
      fromJson: (json) =>
          GymClassResource.fromJson(json as Map<String, dynamic>),
    );
  }

  // ---------------------------------------------------------------------------
  // §13.5  Class Event Detail
  // ---------------------------------------------------------------------------

  /// Returns one specific calendar slot with its parent class embedded.
  Future<ApiResult<ClassEventDetail>> getEventDetail(String eventId) {
    final id = eventId.trim();
    return get<ClassEventDetail>(
      '/classes/events/$id',
      fromJson: (json) =>
          ClassEventDetail.fromJson(json as Map<String, dynamic>),
    );
  }

  // ---------------------------------------------------------------------------
  // §13.6  Book with Plan (session_pack)
  // ---------------------------------------------------------------------------

  /// Body is empty JSON per API contract.
  Future<ApiResult<BookingResource>> bookWithPlan(String calendarEventId) {
    final id = calendarEventId.trim();
    return post<BookingResource>(
      '/classes/$id/book',
      data: <String, dynamic>{},
      fromJson: (json) =>
          BookingResource.fromJson(json as Map<String, dynamic>),
    );
  }

  // ---------------------------------------------------------------------------
  // §13.7  Purchase Single Session
  // ---------------------------------------------------------------------------

  /// Creates enrollment in `pending_payment` state and returns payment URL/token.
  /// [provider] must be `paytabs` or `hyperpay`.
  Future<ApiResult<PurchaseSessionResult>> purchaseSingleSession(
    String calendarEventId,
    String provider,
  ) {
    final id = calendarEventId.trim();
    return post<PurchaseSessionResult>(
      '/classes/$id/purchase',
      data: {'provider': provider},
      fromJson: (json) =>
          PurchaseSessionResult.fromJson(json as Map<String, dynamic>),
    );
  }

  // ---------------------------------------------------------------------------
  // §13.8  Confirm Payment (Safety Net)
  // ---------------------------------------------------------------------------

  /// Idempotent safety net — call only when gateway webhook may not have fired.
  Future<ApiResult<BookingResource>> confirmPayment({
    required String paymentReference,
    required double paidAmount,
    String currency = 'SAR',
  }) {
    return post<BookingResource>(
      '/classes/payment/confirm',
      data: {
        'paymentReference': paymentReference,
        'paidAmount': paidAmount,
        'currency': currency,
      },
      fromJson: (json) =>
          BookingResource.fromJson(json as Map<String, dynamic>),
    );
  }

  // ---------------------------------------------------------------------------
  // §13.9  Join Waitlist
  // ---------------------------------------------------------------------------

  /// Body is empty JSON. Returns [BookingResource] with `waitlisted` status.
  Future<ApiResult<BookingResource>> joinWaitlist(String calendarEventId) {
    final id = calendarEventId.trim();
    return post<BookingResource>(
      '/classes/$id/waitlist',
      data: <String, dynamic>{},
      fromJson: (json) =>
          BookingResource.fromJson(json as Map<String, dynamic>),
    );
  }
}

// ---------------------------------------------------------------------------
// Supporting types
// ---------------------------------------------------------------------------

/// Response from §13.7 — contains enrollment + payment redirect/token info.
class PurchaseSessionResult {
  const PurchaseSessionResult({
    required this.enrollment,
    required this.paymentReference,
    this.paymentUrl,
    this.token,
    required this.provider,
    required this.amount,
    required this.currency,
  });

  final BookingResource enrollment;
  final String paymentReference;

  /// Non-null for PayTabs (redirect flow).
  final String? paymentUrl;

  /// Non-null for HyperPay (SDK/widget flow).
  final String? token;

  final String provider;
  final double amount;
  final String currency;

  factory PurchaseSessionResult.fromJson(Map<String, dynamic> json) {
    final enrollmentMap = json['enrollment'];
    BookingResource enrollment;
    if (enrollmentMap is Map<String, dynamic>) {
      enrollment = BookingResource.fromJson(enrollmentMap);
    } else if (enrollmentMap is Map) {
      enrollment = BookingResource.fromJson(
        Map<String, dynamic>.from(enrollmentMap),
      );
    } else {
      enrollment = BookingResource.fromJson({});
    }

    return PurchaseSessionResult(
      enrollment: enrollment,
      paymentReference: '${json['paymentReference'] ?? json['payment_reference'] ?? ''}',
      paymentUrl:
          json['paymentUrl']?.toString() ??
          json['payment_url']?.toString(),
      token: json['token']?.toString(),
      provider: '${json['provider'] ?? ''}',
      amount: _doubleOrZero(json['amount']),
      currency: '${json['currency'] ?? 'SAR'}',
    );
  }

  static double _doubleOrZero(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0.0;
  }
}
