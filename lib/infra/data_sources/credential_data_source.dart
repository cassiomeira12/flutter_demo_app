import 'package:clean_code_data/clean_code_data.dart';
import 'package:flutter_demo_app/data/data.dart';

class CredentialDataSourceImpl extends BaseCrudDataSourceMixin
    implements CredentialDataSource {
  final HttpClient _http;

  CredentialDataSourceImpl({
    required this._http,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    final request = HttpRequest(
      url: EndpointsEnum.createCredential.endpoint,
      data: data,
    );

    return await mixinCreate(
      http: _http,
      request: request,
      defaultJsonKeys: [],
    );
  }

  @override
  Future<void> delete(String objectId) async {
    final request = HttpRequest(
      url: EndpointsEnum.deleteCredential.endpoint.replaceFirst(
        '{objectId}',
        objectId,
      ),
    );

    await mixinDelete(http: _http, request: request);
  }

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
      url: EndpointsEnum.listCredential.endpoint,
      queryParameters: parameters,
    );

    return await mixinList(
      http: _http,
      request: request,
    );
  }

  @override
  Future<Map<String, dynamic>> update(
    String objectId, {
    required Map<String, dynamic> data,
  }) async {
    final request = HttpRequest(
      url: EndpointsEnum.updateCredential.endpoint.replaceFirst(
        '{objectId}',
        objectId,
      ),
      data: data,
    );

    return await mixinUpdate(
      http: _http,
      request: request,
      defaultJsonKeys: [],
    );
  }

  @override
  Future<Map<String, dynamic>> read(String objectId) {
    throw UnimplementedError();
  }
}
