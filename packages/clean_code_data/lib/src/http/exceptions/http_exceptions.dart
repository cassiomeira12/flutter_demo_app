class HttpException implements Exception {
  final int? statusCode;
  final String? statusMessage;
  final String? message;
  final dynamic data;

  HttpException({
    this.statusCode,
    this.statusMessage,
    this.message,
    this.data,
  });

  @override
  String toString() {
    return 'HttpException \n'
        'statusCode: $statusCode \n'
        'statusMessage: $statusMessage \n'
        'message: $message \n'
        'data: $data \n';
  }
}
