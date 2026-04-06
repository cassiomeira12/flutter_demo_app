import 'package:clean_code_data/clean_code_data.dart';

class LogoutDataSourceImpl implements LogoutDataSource {
  final HttpClient _http;

  LogoutDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<void> logout() async {
    final request = HttpRequest(
      url: EndpointsEnum.logout.endpoint,
    );

    await _http.post(request);
  }
}
