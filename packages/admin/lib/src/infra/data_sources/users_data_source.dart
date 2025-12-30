import 'package:admin/src/data/data.dart';
import 'package:core/core.dart';

class UsersDataSourceImpl with ListDataSourceMixin implements UsersDataSource {
  final HttpClient _http;

  UsersDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<List<Map<String, dynamic>>> list() async {
    final request = HttpRequest(url: EndpointsEnum.listUsers.endpoint);

    return await mixinList(http: _http, request: request);
  }
}
