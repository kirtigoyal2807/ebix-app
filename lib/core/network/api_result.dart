import 'network_exception.dart';

/// Result of an API call: either parsed data or a [NetworkException].
sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;

  R when<R>({
    required R Function(T data, int? statusCode) success,
    required R Function(NetworkException exception) failure,
  }) {
    final self = this;
    if (self is ApiSuccess<T>) {
      return success(self.data, self.statusCode);
    }
    if (self is ApiFailure<T>) {
      return failure(self.exception);
    }
    throw StateError('Unhandled ApiResult');
  }

  T? get dataOrNull => switch (this) {
        ApiSuccess<T>(:final data) => data,
        _ => null,
      };

  NetworkException? get exceptionOrNull => switch (this) {
        ApiFailure<T>(:final exception) => exception,
        _ => null,
      };
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data, {this.statusCode});

  final T data;
  final int? statusCode;
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.exception);

  final NetworkException exception;
}
