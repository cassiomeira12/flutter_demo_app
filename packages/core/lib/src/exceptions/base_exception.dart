class BaseException implements Exception {
  final String? _message;
  final Object? _error;
  final StackTrace? stacktrace;
  final dynamic complement;

  BaseException({
    String? message,
    Object? error,
    this.stacktrace,
    this.complement,
  }) : _message = message?.toString() ?? error.toString(),
       _error = '$error ${complement != null ? '\n\n $complement' : ''}';

  dynamic get error => _error;

  @override
  String toString() {
    return _message ?? error?.toString() ?? runtimeType.toString();
  }
}
