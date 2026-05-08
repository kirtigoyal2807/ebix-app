import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

import '../../core/network/test_repository.dart';

void main() {
  group('AuthRepository.getProfile', () {
    test('GET auth/me parses envelope data into AuthUser', () async {
      RequestOptions? seen;
      final dio = createTestDio(
        onRequest: (options, handler) {
          seen = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'success': true,
                'message': 'Profile fetched',
                'data': {
                  'id': 42,
                  'name': 'Noor Ali',
                  'email': 'noor@example.com',
                  'phone': '+966500000001',
                  'avatar': 'https://cdn.example.com/storage/avatars/noor.jpg',
                  'language': 'en',
                  'dob': '1995-01-20',
                  'gender': 'female',
                  'homeBranch': {
                    'id': 2,
                    'name': 'Riyadh - Olaya',
                    'slug': 'riyadh-olaya',
                    'code': 'RYD-01',
                  },
                  'brands': [
                    {'id': 1, 'name': 'The Pilates'},
                  ],
                  'goals': {
                    'experience': 'intermediate',
                    'goal': 'Lose weight',
                    'monthlyGoal': 12,
                  },
                  'subscriptions': [
                    {
                      'id': 'uuid',
                      'status': 'active',
                      'entitlementType': 'subscription',
                      'startsAt': '2026-03-01 00:00:00',
                      'expiresAt': '2026-04-01 00:00:00',
                      'isActive': true,
                      'isPaid': true,
                      'pricePaid': 299.0,
                      'isTransferable': false,
                      'product': {'id': 10, 'name': 'Reformer Monthly'},
                      'sessions': {'total': null, 'used': 0, 'remaining': null},
                      'freezes': [],
                    },
                  ],
                  'pendingGift': null,
                  'emailVerified': true,
                  'phoneVerified': true,
                  'createdAt': '2026-01-10T10:00:00+03:00',
                  'updatedAt': '2026-03-01T08:00:00+03:00',
                },
              },
            ),
          );
        },
      );

      final result = await AuthRepository(dio).getProfile();

      expect(result.isSuccess, isTrue);
      expect(seen?.method, 'GET');
      expect(seen?.path, 'auth/me');

      expect(result.dataOrNull, isA<AuthUser>());
      final user = result.dataOrNull!;
      expect(user.id, '42');
      expect(user.name, 'Noor Ali');
      expect(user.email, 'noor@example.com');
      expect(user.phone, '+966500000001');
      expect(user.avatar, 'https://cdn.example.com/storage/avatars/noor.jpg');
      expect(user.language, 'en');
      expect(user.gender, 'female');
      expect(user.dateOfBirth, DateTime(1995, 1, 20));
      expect(user.homeBranch?.id, 2);
      expect(user.homeBranch?.name, 'Riyadh - Olaya');
      expect(user.homeBranch?.slug, 'riyadh-olaya');
      expect(user.homeBranch?.code, 'RYD-01');
      expect(user.brands?.length, 1);
      expect(user.brands?.first.id, 1);
      expect(user.brands?.first.name, 'The Pilates');
      expect(user.goals?.experience, 'intermediate');
      expect(user.goals?.goal, 'Lose weight');
      expect(user.goals?.monthlyGoal, 12);
      expect(user.subscriptions?.length, 1);
      expect(user.subscriptions?.first.status, 'active');
      expect(user.subscriptions?.first.product?.name, 'Reformer Monthly');
      expect(user.emailVerified, isTrue);
      expect(user.phoneVerified, isTrue);
      expect(user.pendingGift, isNull);
      expect(user.hasPendingGiftKey, isTrue);
      // Membership info from subscriptions fallback
      expect(user.membershipPlanName, 'Reformer Monthly');
    });

    test('GET auth/me parses pendingGift into typed PendingGift', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'success': true,
                'message': 'Profile fetched',
                'data': {
                  'id': 42,
                  'name': 'Noor Ali',
                  'pendingGift': {
                    'id': '94b6a623-4467-4869-9093-13a328038ef8',
                    'status': {'value': 'sent', 'label': 'Sent'},
                    'redemptionCode': 'GIFT-RPAF-BLHY',
                    'recipient': {
                      'name': 'hfgh ghg',
                      'phone': '+9661234567890',
                      'email': 'test@mailinator.com',
                    },
                    'message': 'Happy Birthday!\n— Ayesha',
                    'deliveryDate': null,
                    'sentAt': '2026-05-06 16:13:06',
                    'redeemedAt': null,
                    'expiresAt': '2027-05-06 16:13:06',
                    'isRedeemed': false,
                    'isExpired': false,
                    'canBeRedeemed': true,
                    'createdAt': '2026-05-06 16:13:06',
                  },
                },
              },
            ),
          );
        },
      );

      final result = await AuthRepository(dio).getProfile();
      expect(result.isSuccess, isTrue);
      final gift = result.dataOrNull!.pendingGift;
      expect(gift, isNotNull);
      expect(gift!.id, '94b6a623-4467-4869-9093-13a328038ef8');
      expect(gift.status, 'sent');
      expect(gift.statusLabel, 'Sent');
      expect(gift.redemptionCode, 'GIFT-RPAF-BLHY');
      expect(gift.canBeRedeemed, isTrue);
      expect(gift.isRedeemed, isFalse);
      expect(gift.recipient?.name, 'hfgh ghg');
      expect(gift.recipient?.phone, '+9661234567890');
      expect(gift.message, 'Happy Birthday!\n— Ayesha');
    });

    test('GET auth/me uses envelope success path only', () async {
      RequestOptions? seen;
      final dio = createTestDio(
        onRequest: (options, handler) {
          seen = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {'success': false, 'message': 'nope', 'data': null},
            ),
          );
        },
      );
      final result = await AuthRepository(dio).getProfile();
      expect(result.isFailure, isTrue);
      expect(seen?.path, 'auth/me');
      expect(result.exceptionOrNull?.message, 'nope');
    });
  });
}
