import 'package:clean_code_data/clean_code_data.dart';

class WorkPointRefreshTokenDataSource implements RefreshTokenDataSource {
  final LoginDataSource _loginDataSource;

  WorkPointRefreshTokenDataSource({required this._loginDataSource});

  @override
  Future<Map<String, dynamic>> refresh() async {
    return await _loginDataSource.login(username: '', password: '');
  }
}
