import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:pilates_app/core/network/api_envelope.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/checkout/data/models/catalog_product.dart';
import 'package:pilates_app/features/checkout/data/models/checkout_payment_intent_result.dart';
import 'package:pilates_app/features/checkout/data/models/checkout_start_result.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_questionnaire.dart';

/// Checkout session APIs.
///
/// **Suggested Hoppscotch order** (paths are relative to the API base URL, e.g.
/// `https://dev.thepilates.sa/api/v1/`):
/// 1. `POST checkout/start` — body must include `"isGift": true` for gift flows;
///    otherwise `POST checkout/{id}/gift` returns **422** `"Not a gift"`.
/// 2. Gift recipient step: `POST checkout/{id}/gift` ([submitGiftDetails]).
/// 3. Optional: `GET checkout/{id}` — refresh session ([getCheckoutDetails]).
/// 4. `GET /products/{id}` — single product ([getProduct]).
/// 5. `GET health-intake/questionnaires/product/{productId}` — schemas by product
///    ([getQuestionsByProduct]), or `GET health-intake/questionnaires/{id}` for one form
///    ([getQuestionnaireById]).
/// 6. `POST checkout/{id}/health-intake` — submit answers; response `data` is the
///    same shape as checkout detail, including object `metadata` (e.g.
///    `health_intake_id`) ([submitHealthIntake]).
/// 7. After cart review: `POST checkout/{id}/apply-coupon` — voucher
///    ([applyCoupon]); adjust to `coupon` if needed.
/// 8. Payment: `POST checkout/{id}/payment/intent` — same resource as
///    `…/checkout/019c70d5-…/payment/intent` under the API base ([fetchPaymentIntent]).
class CheckoutRepository extends BaseRepository {
  CheckoutRepository(super.dio);

  /// `GET /products` — catalog list (`data`: array of product objects).
  ///
  /// Pass [branchId] to filter by branch (`?branchId=` query param).
  /// Only [CatalogProduct.isActive] rows are returned.
  Future<ApiResult<List<CatalogProduct>>> listProducts({int? branchId}) {
    final queryParameters = (branchId != null && branchId > 0)
        ? <String, dynamic>{'branchId': branchId}
        : null;
    if (kDebugMode) {
      debugPrint(
        '[Checkout] request GET products'
        '${queryParameters != null ? ' query=$queryParameters' : ''}',
      );
    }
    return get<List<CatalogProduct>>(
      'products',
      queryParameters: queryParameters,
      fromJson: CatalogProduct.listFromEnvelopeData,
    );
  }

  /// `GET /products/{id}` — single product (`data`: one product object, same fields as list rows).
  ///
  /// Pass [branchId] when the API scopes price/availability by branch (same as [listProducts]).
  Future<ApiResult<CatalogProduct>> getProduct(
    int productId, {
    int? branchId,
  }) async {
    if (productId <= 0) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Invalid product id.',
        ),
      );
    }
    final queryParameters = (branchId != null && branchId > 0)
        ? <String, dynamic>{'branchId': branchId}
        : null;
    if (kDebugMode) {
      debugPrint(
        '[Checkout] request GET products/$productId'
        '${queryParameters != null ? ' query=$queryParameters' : ''}',
      );
    }
    return get<CatalogProduct>(
      'products/${Uri.encodeComponent(productId.toString())}',
      queryParameters: queryParameters,
      fromJson: CatalogProduct.fromEnvelopeData,
    );
  }

  /// `POST /checkout/start` — creates a draft checkout; use [CheckoutStartResult.id]
  /// for `POST /checkout/{id}/gift` and payment steps.
  ///
  /// Request shape matches mobile API (camelCase). Adjust if backend expects snake_case.
  Future<ApiResult<CheckoutStartResult>> startCheckout({
    required int productId,
    required int branchId,
    required bool isGift,
  }) async {
    if (productId <= 0 || branchId <= 0) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Invalid product or branch selection.',
        ),
      );
    }

    final body = <String, dynamic>{
      'productId': productId,
      'branchId': branchId,
      'isGift': isGift,
    };
    if (kDebugMode) {
      debugPrint('[Checkout] request POST checkout/start body=$body');
    }

    try {
      final response = await httpClient.post<dynamic>(
        'checkout/start',
        data: body,
      );
      return _checkoutStartFromResponse(response);
    } on DioException catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[Checkout] checkout/start DioException type=${e.type} '
          'status=${e.response?.statusCode} data=${e.response?.data}',
        );
      }
      return ApiFailure(NetworkException.fromDioException(e, st));
    } catch (e, st) {
      return ApiFailure(NetworkException.fromUnknown(e, st));
    }
  }

  ApiResult<CheckoutStartResult> _checkoutStartFromResponse(
    Response<dynamic> response,
  ) {
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
    try {
      final envelope = ApiEnvelopeParser.tryParse(raw);
      if (envelope != null) {
        if (!envelope.success) {
          return ApiFailure(
            NetworkException.fromApiEnvelope(
              statusCode: code,
              message: envelope.message.isEmpty ? 'Request failed' : envelope.message,
              fieldErrors: envelope.fieldErrors,
              responseData: raw,
            ),
          );
        }

        final payload = envelope.data;
        if (payload is! Map) {
          return ApiFailure(
            NetworkException(
              type: NetworkFailureType.unknown,
              message: 'Invalid checkout start payload',
              statusCode: code,
              responseData: raw,
            ),
          );
        }

        final meta = envelope.meta ?? const <dynamic>[];
        final parsed = CheckoutStartResult.fromJson(
          Map<String, dynamic>.from(payload),
          responseMeta: meta,
        );

        if (kDebugMode) {
          final total = parsed.pricing?.totalAmount;
          final cur = parsed.pricing?.currency ?? '';
          debugPrint(
            '[Checkout] response meta (envelope)=${parsed.responseMeta.length} '
            'items total=$total $cur draft=${parsed.status?.value}',
          );
        }

        return ApiSuccess(parsed, statusCode: code);
      }

      if (raw is Map) {
        final parsed = CheckoutStartResult.fromJson(
          Map<String, dynamic>.from(raw),
        );
        return ApiSuccess(parsed, statusCode: code);
      }

      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.unknown,
          message: 'Unexpected checkout start response',
          statusCode: code,
          responseData: raw,
        ),
      );
    } catch (e, st) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.unknown,
          message: 'Failed to parse checkout start: $e',
          statusCode: code,
          responseData: raw,
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// `POST /checkout/{checkout}/gift`
  ///
  /// JSON body: `recipientName`, `recipientEmail`, `recipientPhone`, optional
  /// `message`, optional `deliveryDate` as **`yyyy-MM-dd`** (scheduled delivery).
  ///
  /// Failure envelope example: `{ "success": false, "message": "Not a gift" }`
  /// — returned when the checkout session is **not** gift-eligible (wrong cart /
  /// wrong checkout id). Shown to the user via [NetworkException.message].
  Future<ApiResult<bool>> submitGiftDetails({
    required String checkoutId,
    required String recipientName,
    required String recipientEmail,
    required String recipientPhone,
    String? message,
    String? deliveryDate,
  }) async {
    final id = checkoutId.trim();
    if (id.isEmpty) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Missing checkout session id.',
        ),
      );
    }

    final rn = recipientName.trim();
    final re = recipientEmail.trim();
    final rp = recipientPhone.trim();
    if (rn.isEmpty || re.isEmpty) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Recipient name and email are required.',
        ),
      );
    }

    final body = <String, dynamic>{
      'recipientName': rn,
      'recipientEmail': re,
      'recipientPhone': rp,
    };
    final m = message?.trim();
    if (m != null && m.isNotEmpty) {
      body['message'] = m;
    }
    final normalizedDate = normalizeGiftDeliveryDate(deliveryDate);
    if (normalizedDate != null && normalizedDate.isNotEmpty) {
      body['deliveryDate'] = normalizedDate;
    }

    if (kDebugMode) {
      debugPrint(
        '[Gift checkout] request POST .../checkout/$id/gift body=$body',
      );
    }

    final result = await post<bool>(
      'checkout/${Uri.encodeComponent(id)}/gift',
      data: body,
      fromJson: (_) => true,
    );

    if (kDebugMode) {
      result.when(
        success: (data, statusCode) {
          debugPrint(
            '[Gift checkout] response OK http=$statusCode parsed=$data',
          );
        },
        failure: (exception) {
          debugPrint(
            '[Gift checkout] response FAIL http=${exception.statusCode} '
            'message=${exception.message} raw=${exception.responseData}',
          );
        },
      );
    }

    return result;
  }

  /// `GET /checkout/{checkout}` — current checkout session (same shape as start `data`).
  Future<ApiResult<CheckoutStartResult>> getCheckoutDetails(
    String checkoutId,
  ) async {
    final id = checkoutId.trim();
    if (id.isEmpty) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Missing checkout session id.',
        ),
      );
    }

    if (kDebugMode) {
      debugPrint('[Checkout] request GET checkout/$id');
    }

    return get<CheckoutStartResult>(
      'checkout/${Uri.encodeComponent(id)}',
      fromJson: (payload) {
        if (payload is! Map) {
          throw StateError('Expected checkout session object');
        }
        return CheckoutStartResult.fromJson(
          Map<String, dynamic>.from(payload),
        );
      },
    );
  }

  /// `POST /checkout/{checkout}/health-intake` — persists health questionnaire.
  ///
  /// Success envelope `data` matches [CheckoutStartResult], including
  /// **`metadata`** as an object when the API returns e.g. `health_intake_id`.
  Future<ApiResult<CheckoutStartResult>> submitHealthIntake({
    required String checkoutId,
    required Map<String, dynamic> body,
  }) async {
    final id = checkoutId.trim();
    if (id.isEmpty) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Missing checkout session id.',
        ),
      );
    }

    if (kDebugMode) {
      debugPrint(
        '[Checkout] request POST checkout/$id/health-intake keys=${body.keys.toList()}',
      );
    }

    return post<CheckoutStartResult>(
      'checkout/${Uri.encodeComponent(id)}/health-intake',
      data: body,
      fromJson: (payload) {
        if (payload is! Map) {
          throw StateError('Expected checkout session object');
        }
        return CheckoutStartResult.fromJson(
          Map<String, dynamic>.from(payload),
        );
      },
    );
  }

  /// `GET /health-intake/questionnaires/product/{productId}` — questionnaire(s)
  /// for checkout health intake (`data.questionnaires[].questions[]`).
  ///
  /// Legacy: `GET /products/{productId}/questions` — use only if your backend has not
  /// migrated; swap the path below.
  Future<ApiResult<ProductHealthQuestionnaire>> getQuestionsByProduct({
    required int productId,
  }) async {
    if (productId <= 0) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Invalid product id.',
        ),
      );
    }

    if (kDebugMode) {
      debugPrint(
        '[Checkout] request GET health-intake/questionnaires/product/$productId',
      );
    }

    return get<ProductHealthQuestionnaire>(
      'health-intake/questionnaires/product/$productId',
      fromJson: ProductHealthQuestionnaire.fromEnvelopeData,
    );
  }

  /// `GET /health-intake/questionnaires/{questionnaireId}` — single questionnaire
  /// (`data.questionnaire.questions[]`).
  Future<ApiResult<ProductHealthQuestionnaire>> getQuestionnaireById({
    required int questionnaireId,
  }) async {
    if (questionnaireId <= 0) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Invalid questionnaire id.',
        ),
      );
    }

    if (kDebugMode) {
      debugPrint(
        '[Checkout] request GET health-intake/questionnaires/$questionnaireId',
      );
    }

    return get<ProductHealthQuestionnaire>(
      'health-intake/questionnaires/$questionnaireId',
      fromJson: ProductHealthQuestionnaire.fromEnvelopeData,
    );
  }

  /// `POST /checkout/{checkout}/apply-coupon` — body `{ "code": "<voucher>" }`.
  Future<ApiResult<CheckoutStartResult>> applyCoupon({
    required String checkoutId,
    required String code,
  }) async {
    final id = checkoutId.trim();
    final c = code.trim();
    if (id.isEmpty) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Missing checkout session id.',
        ),
      );
    }
    if (c.isEmpty) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Enter a voucher code.',
        ),
      );
    }

    if (kDebugMode) {
      debugPrint('[Checkout] request POST checkout/$id/apply-coupon');
    }

    return post<CheckoutStartResult>(
      'checkout/${Uri.encodeComponent(id)}/apply-coupon',
      data: <String, dynamic>{'code': c},
      fromJson: (payload) {
        if (payload is! Map) {
          throw StateError('Expected checkout session object');
        }
        return CheckoutStartResult.fromJson(
          Map<String, dynamic>.from(payload),
        );
      },
    );
  }

  /// `POST /checkout/{checkout}/payment/intent` — creates payment / client secret / URL.
  ///
  /// When the API returns `success: false` with a message like
  /// **"Payment for this checkout is already completed"**, this returns
  /// [ApiSuccess] with [CheckoutPaymentIntentResult.alreadyCompleted] set so
  /// clients can finish the flow without treating it as a hard error.
  ///
  /// Matches: `…/api/v1/checkout/{uuid}/payment/intent` under the configured base URL.
  /// If your backend uses `GET` instead, switch to [get] with the same path.
  Future<ApiResult<CheckoutPaymentIntentResult>> fetchPaymentIntent(
    String checkoutId,
  ) async {
    final id = checkoutId.trim();
    if (id.isEmpty) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Missing checkout session id.',
        ),
      );
    }

    if (kDebugMode) {
      debugPrint('[Checkout] request POST checkout/$id/payment/intent');
    }

    final result = await post<CheckoutPaymentIntentResult>(
      'checkout/${Uri.encodeComponent(id)}/payment/intent',
      data: const <String, dynamic>{},
      fromJson: CheckoutPaymentIntentResult.fromJson,
    );

    if (result.isFailure) {
      final ex = result.exceptionOrNull!;
      if (isCheckoutPaymentAlreadyCompletedMessage(ex.message)) {
        if (kDebugMode) {
          debugPrint(
            '[Checkout] payment/intent already completed — continuing as success',
          );
        }
        return ApiSuccess(
          const CheckoutPaymentIntentResult(alreadyCompleted: true),
          statusCode: ex.statusCode,
        );
      }
    }

    return result;
  }

  /// `true` when [message] is the known "checkout already paid" API copy.
  static bool isCheckoutPaymentAlreadyCompletedMessage(String? message) {
    final t = message?.toLowerCase().trim() ?? '';
    if (t.isEmpty) return false;
    return t.contains('already completed') &&
        (t.contains('payment') || t.contains('paid'));
  }

  /// Accepts ISO-ish strings (including `2026-05-1`) and outputs `yyyy-MM-dd`.
  static String? normalizeGiftDeliveryDate(String? raw) {
    if (raw == null) return null;
    final t = raw.trim();
    if (t.isEmpty) return null;

    var d = DateTime.tryParse(t);
    if (d != null) {
      return _formatYmd(d);
    }

    final parts = t.split(RegExp(r'[-/]'));
    if (parts.length >= 3) {
      final y = int.tryParse(parts[0].trim());
      final month = int.tryParse(parts[1].trim());
      final day = int.tryParse(parts[2].trim());
      if (y != null && month != null && day != null) {
        d = DateTime(y, month, day);
        return _formatYmd(d);
      }
    }
    return null;
  }

  static String _formatYmd(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}
