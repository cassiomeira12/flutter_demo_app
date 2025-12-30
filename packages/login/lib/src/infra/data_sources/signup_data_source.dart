import 'package:core/core.dart';
import 'package:login/src/data/data.dart';

class SignupDataSourceImpl
    with CreateDataSourceMixin
    implements SignupDataSource {
  final HttpClient _http;

  SignupDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) {
    final request = HttpRequest(url: EndpointsEnum.signup.endpoint, data: data);

    return mixinCreate(http: _http, request: request);
  }
}
