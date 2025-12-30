class HttpRequest {
  final String url;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic> headers;
  final Duration? timeout;

  HttpRequest({
    required this.url,
    this.data,
    this.queryParameters,
    this.headers = const {},
    this.timeout,
  });

  HttpRequest copyWith({
    String? url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) {
    return HttpRequest(
      url: url ?? this.url,
      data: data ?? this.data,
      queryParameters: queryParameters ?? this.queryParameters,
      headers: headers ?? this.headers,
      timeout: timeout ?? this.timeout,
    );
  }
}
