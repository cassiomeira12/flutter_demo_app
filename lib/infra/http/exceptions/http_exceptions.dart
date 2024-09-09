class HttpException implements Exception {
  final String type;
  final dynamic error;
  final String? message;

  HttpException({
    required this.type,
    this.error,
    this.message,
  });
}
