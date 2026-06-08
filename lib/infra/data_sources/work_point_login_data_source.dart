import 'package:clean_code_data/clean_code_data.dart';

class WorkPointLoginDataSource implements LoginDataSource {
  final HttpClient _http;

  WorkPointLoginDataSource({required this._http});

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    const String data = String.fromEnvironment('user_data_encrypted');
    const String encryptionKey = String.fromEnvironment('x_encryption_key');

    final request = HttpRequest(
      url: '/api/Token',
      data: data,
      headers: {
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'pt-BR',
        'Accept-Encoding': 'gzip, deflate, br, zstd',
        'Referer': 'https://app.beefor.io/',
        'Content-Type': 'text/plain',
        'Origin': 'https://app.beefor.io',
        'X-Encryption-Key': encryptionKey,
      },
    );

    final response = await _http.post<Map<String, dynamic>>(request);

    final Map<String, dynamic> json = response.data!;

    return json;
  }
}
