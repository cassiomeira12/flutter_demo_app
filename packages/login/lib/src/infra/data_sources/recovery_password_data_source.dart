import 'package:core/core.dart';
import 'package:login/src/data/data.dart';

class RecoveryPasswordDataSourceImpl implements RecoveryPasswordDataSource {
  final HttpClient _http;

  RecoveryPasswordDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<void> recoveryPassword(String email) async {
    final request = HttpRequest(
      url: EndpointsEnum.recoveryPassword.endpoint,
      data: {'email': email},
    );

    await _http.post<Map<String, dynamic>>(request);
  }
}
