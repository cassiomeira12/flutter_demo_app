import 'package:clean_code_data/clean_code_data.dart';

class UserDataSourceImpl
    with ReadDtaSourceMixin, DeleteDataSourceMixin, UpdateDataSourceMixin
    implements UserDataSource {
  final HttpClient _http;

  UserDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<Map<String, dynamic>> getUserData() async {
    final request = HttpRequest(url: EndpointsEnum.userData.endpoint);

    return await mixinRead(
      http: _http,
      request: request,
      method: HttpMethod.POST,
    );
  }

  @override
  Future<void> updateUserData({
    required String objectId,
    required Map<String, dynamic> data,
  }) async {
    final request = HttpRequest(
      url: EndpointsEnum.updateUserData.endpoint.replaceFirst(
        '{objectId}',
        objectId,
      ),
      data: data,
    );

    await mixinUpdate(
      http: _http,
      request: request,
      defaultJsonKeys: [],
    );
  }

  @override
  Future<void> deleteUser({required String reason}) async {
    final request = HttpRequest(
      url: EndpointsEnum.deleteUserAccount.endpoint,
      data: {'reason': reason},
    );

    await mixinDelete(
      http: _http,
      request: request,
      method: HttpMethod.POST,
    );
  }

  @override
  Future<Map<String, dynamic>> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final data = {
        'username': username,
        'password': currentPassword,
        'newPassword': newPassword,
      };

      final request = HttpRequest(
        url: EndpointsEnum.changeUserPassword.endpoint,
        data: data,
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      return json['result'] as Map<String, dynamic>;
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
