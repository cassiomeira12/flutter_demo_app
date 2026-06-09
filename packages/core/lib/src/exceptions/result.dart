import 'package:core/core.dart';

abstract class Result<T> {
  const Result();

  static Success<T> success<T>([T? value]) {
    return Success<T>(value);
  }

  static Error<T> error<T>(BaseException error) {
    return Error<T>(error);
  }
}

class Success<T> extends Result<T> {
  final T? value;
  const Success([this.value]);
}

class Error<T> extends Result<T> {
  final BaseException error;
  const Error(this.error);
}
