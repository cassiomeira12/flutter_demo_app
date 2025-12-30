import 'package:clean_code_data/clean_code_data.dart';

class AppInstallationDataSourceImpl
    with CreateDataSourceMixin, ListDataSourceMixin
    implements AppInstallationDataSource {
  final HttpClient _http;

  AppInstallationDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) {
    final request = HttpRequest(
      url: EndpointsEnum.uploadInstallations.endpoint,
      data: data,
    );

    return mixinCreate(http: _http, request: request);
  }

  @override
  Future<List<Map<String, dynamic>>> list(String userId) {
    final request = HttpRequest(
      url: EndpointsEnum.listUserInstallations.endpoint,
      data: {'userId': userId},
    );

    return mixinList(
      http: _http,
      request: request,
      method: HttpMethod.POST,
      defaultJsonKeys: ['result'],
    );
  }
}
