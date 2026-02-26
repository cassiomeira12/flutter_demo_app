import 'package:core/core.dart';

class LoginServiceImpl implements LoginService {
  final LoginDataSource _dataSource;

  LoginServiceImpl({required LoginDataSource loginDataSource})
    : _dataSource = loginDataSource;

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> result = await _dataSource.login(
        username: username,
        password: password,
      );

      final UserModel user = UserModel.fromMap(result);

      return user;
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error('login', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'login',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
