import 'package:core/core.dart';

class LoginDataSourceImpl implements LoginDataSource {
  final HttpClient _http;

  LoginDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final authUser = {'username': username, 'password': password};

      final request = HttpRequest(
        url: EndpointsEnum.login.endpoint,
        data: authUser,
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      return json['result'] as Map<String, dynamic>;
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
