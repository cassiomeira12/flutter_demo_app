class BaseException implements Exception {
  final String _message;
  final Object? error;
  final StackTrace? stackTrace;
  final dynamic complement;

  final bool throwReport;

  BaseException({
    String? message,
    this.error,
    this.stackTrace,
    this.complement,
    this.throwReport = true,
  }) : _message = message ?? 'default_error';

  String get message => _message;

  @override
  String toString() {
    return 'BaseException \n'
        'message: $message \n'
        'error: $error \n'
        'complement: $complement \n'
        'stackTrace: $stackTrace \n';
  }
}
