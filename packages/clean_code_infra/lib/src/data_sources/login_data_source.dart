import 'package:clean_code_data/clean_code_data.dart';

class LoginDataSourceImpl implements LoginDataSource {
  final HttpClient _http;

  LoginDataSourceImpl({required this._http});

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final request = HttpRequest(
      url: EndpointsEnum.login.endpoint,
      data: {
        'username': username,
        'password': password,
      },
    );

    final response = await _http.post<Map<String, dynamic>>(request);

    final Map<String, dynamic> json = response.data!;

    return json['result'] as Map<String, dynamic>;
  }
}
