class HttpResponse<T> {
  final T? data;
  final int? statusCode;
  final String? statusMessage;
  final Map<String, dynamic>? headers;

  HttpResponse({
    this.data,
    this.statusCode,
    this.statusMessage,
    this.headers,
  });
}
