import 'package:clean_code_data/clean_code_data.dart';

class WebVisitHistoryDataSourceImpl
    with ListDataSourceMixin
    implements WebVisitHistoryDataSource {
  final HttpClient _http;

  WebVisitHistoryDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<List<Map<String, dynamic>>> list() async {
    final request = HttpRequest(
      url: EndpointsEnum.listWebVisitHistory.endpoint,
    );

    return await mixinList(
      http: _http,
      request: request,
      method: HttpMethod.POST,
    );
  }
}
