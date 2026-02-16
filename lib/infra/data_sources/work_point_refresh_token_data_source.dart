import 'package:core/core.dart';

class WorkPointRefreshTokenDataSource implements RefreshTokenDataSource {
  final LoginDataSource _loginDataSource;

  WorkPointRefreshTokenDataSource({
    required LoginDataSource loginDataSource,
  }) : _loginDataSource = loginDataSource;

  @override
  Future<Map<String, dynamic>> refresh() async {
    return await _loginDataSource.login(username: '', password: '');
  }
}
