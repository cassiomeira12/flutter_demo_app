// ignore_for_file: constant_identifier_names

enum HttpMethod {
  GET('GET'),
  POST('POST'),
  PUT('PUT'),
  PATCH('PATCH'),
  DELETE('DELETE'),
  OPTIONS('OPTIONS'),
  HEAD('HEAD')
  ;

  const HttpMethod(this.name);

  final String name;

  static HttpMethod fromString(String method) {
    return HttpMethod.values.firstWhere(
      (e) => e.name == method,
      orElse: () => throw ArgumentError('Invalid HTTP method: $method'),
    );
  }
}
