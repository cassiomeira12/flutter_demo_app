import 'package:core/core.dart';

class LogoutServiceImpl implements LogoutService {
  final LogoutDataSource _dataSource;

  LogoutServiceImpl({required LogoutDataSource logoutDataSource})
    : _dataSource = logoutDataSource;

  @override
  Future<void> logout() async {
    try {
      await _dataSource.logout();
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error('logout', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'logout',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
