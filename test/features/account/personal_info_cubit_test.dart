import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/account/cubit/personal_info_cubit.dart';
import 'package:pilates_app/features/account/cubit/personal_info_state.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

void main() {
  group('PersonalInfoCubit', () {
    test(
      'loadProfile prefills personal fields from profile response',
      () async {
        final repository = _TestAuthRepository();
        final cubit = PersonalInfoCubit(authRepository: repository);

        await cubit.loadProfile();

        expect(cubit.state.loadStatus, PersonalInfoLoadStatus.loaded);
        expect(cubit.state.firstName, 'Noor');
        expect(cubit.state.lastName, 'Ali');
        expect(cubit.state.email, 'noor@example.com');
        expect(cubit.state.phone, '+966500000001');
        expect(cubit.state.gender, 'female');
        expect(cubit.state.marketingOptIn, isTrue);
        expect(cubit.state.hasChanges, isFalse);

        await cubit.close();
      },
    );

    test('submit sends only changed profile fields', () async {
      final repository = _TestAuthRepository();
      final cubit = PersonalInfoCubit(authRepository: repository);

      await cubit.loadProfile();
      cubit.updateFirstName('Noor Mohammed');
      await cubit.submit();

      expect(repository.updateCalls, 1);
      expect(repository.lastName, 'Noor Mohammed Ali');
      expect(repository.lastPhone, isNull);
      expect(repository.lastDob, isNull);
      expect(repository.lastGender, isNull);
      expect(repository.lastMarketingOptIn, isNull);
      expect(repository.lastAvatarPath, isNull);
      expect(cubit.state.saveStatus, PersonalInfoSaveStatus.success);

      await cubit.close();
    });
  });
}

class _TestAuthRepository extends AuthRepository {
  _TestAuthRepository()
    : super(Dio(BaseOptions(baseUrl: 'https://test.local/')));

  int updateCalls = 0;
  String? lastName;
  String? lastPhone;
  DateTime? lastDob;
  String? lastGender;
  bool? lastMarketingOptIn;
  String? lastAvatarPath;

  @override
  Future<ApiResult<AuthUser>> getProfile() async {
    return const ApiSuccess<AuthUser>(
      AuthUser(
        name: 'Noor Ali',
        firstName: 'Noor',
        lastName: 'Ali',
        email: 'noor@example.com',
        phone: '+966500000001',
        dob: '1995-01-20',
        gender: 'female',
        marketingOptIn: true,
        avatar: 'https://cdn.example.com/noor.jpg',
      ),
    );
  }

  @override
  Future<ApiResult<AuthUser>> updateProfile({
    String? name,
    String? phone,
    DateTime? dob,
    String? gender,
    bool? marketingOptIn,
    String? avatarPath,
  }) async {
    updateCalls++;
    lastName = name;
    lastPhone = phone;
    lastDob = dob;
    lastGender = gender;
    lastMarketingOptIn = marketingOptIn;
    lastAvatarPath = avatarPath;
    return ApiSuccess<AuthUser>(
      AuthUser(
        name: name ?? 'Noor Ali',
        firstName: 'Noor',
        lastName: 'Ali',
        email: 'noor@example.com',
        phone: phone ?? '+966500000001',
        dob: (dob != null)
            ? '${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}'
            : '1995-01-20',
        gender: gender ?? 'female',
        marketingOptIn: marketingOptIn ?? true,
        avatar: 'https://cdn.example.com/noor.jpg',
      ),
    );
  }
}
