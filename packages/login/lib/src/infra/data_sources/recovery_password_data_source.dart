import 'package:clean_code_data/clean_code_data.dart';
import 'package:dependency/dependency.dart';
import 'package:login/src/data/data_sources/data_sources.dart';

class RecoveryPasswordDataSourceImpl implements RecoveryPasswordDataSource {
  final HttpClient _http;

  RecoveryPasswordDataSourceImpl({required this._http});

  @override
  Future<void> recoveryPassword(String email) async {
    final request = HttpRequest(
      url: EndpointsEnum.recoveryPassword.endpoint,
      data: {'email': email},
    );

    await _http.post<Map<String, dynamic>>(request);
  }
}
