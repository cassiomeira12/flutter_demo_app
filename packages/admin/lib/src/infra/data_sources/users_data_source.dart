import 'package:admin/src/data/data.dart';
import 'package:core/core.dart';

class UsersDataSourceImpl with ListDataSourceMixin implements UsersDataSource {
  final HttpClient _http;

  UsersDataSourceImpl({required HttpClient http}) : _http = http;

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
      url: EndpointsEnum.listUsers.endpoint,
      queryParameters: parameters,
    );

    return await mixinList(
      http: _http,
      request: request,
    );
  }
}
