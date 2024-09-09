class HttpRequest {
  final String url;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic> headers;

  HttpRequest({
    required this.url,
    this.data,
    this.queryParameters,
    this.headers = const {},
  });
}
