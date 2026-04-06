import 'package:core/core.dart';

class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T? value;
  const Success([this.value]);
}

class Error<T> extends Result<T> {
  final BaseException error;
  const Error(this.error);
}
