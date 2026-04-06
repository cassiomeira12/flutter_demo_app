import 'package:clean_code_data/clean_code_data.dart';

class WebVisitHistoryDataSourceImpl
    with ListDataSourceMixin
    implements WebVisitHistoryDataSource {
  final HttpClient _http;

  WebVisitHistoryDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<List<Map<String, dynamic>>> list({
    int limit = 100,
    int skip = 0,
    String order = '-updatedAt',
    String? where,
  }) async {
    final Map<String, dynamic> parameters = {
      'limit': limit,
      'skip': skip,
      'order': order,
    };

    if (where != null) parameters['where'] = where;

    final request = HttpRequest(
      url: EndpointsEnum.listWebVisitHistory.endpoint,
      queryParameters: parameters,
    );

    return await mixinList(
      http: _http,
      request: request,
    );
  }
}
