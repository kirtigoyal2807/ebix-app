import 'package:dio/dio.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/booking/data/models/gym_class_resource.dart';

/// Test double for booking class list / detail APIs.
class FakeClassesRepository extends ClassesRepository {
  FakeClassesRepository()
    : super(Dio(BaseOptions(baseUrl: 'https://test.local/')));

  ApiResult<GymClassResource> getClassDetailResult =
      ApiFailure<GymClassResource>(
        NetworkException(type: NetworkFailureType.unknown, message: 'unset'),
      );

  int getClassDetailCalls = 0;
  String? lastClassDetailId;

  @override
  Future<ApiResult<GymClassResource>> getClassDetail(String classId) async {
    getClassDetailCalls++;
    lastClassDetailId = classId;
    return getClassDetailResult;
  }
}
