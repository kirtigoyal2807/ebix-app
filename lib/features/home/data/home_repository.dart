import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/home_response.dart';

class HomeRepository extends BaseRepository {
  HomeRepository(super.dio);

  Future<ApiResult<HomeResponse>> fetchHome() {
    return get<HomeResponse>(
      'home/',
      fromJson: (json) => HomeResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
