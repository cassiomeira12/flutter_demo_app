import 'package:core/core.dart';

class LogoutServiceImpl implements LogoutService {
  final LogoutDataSource _dataSource;

  LogoutServiceImpl({required LogoutDataSource logoutDataSource})
    : _dataSource = logoutDataSource;

  @override
  Future<void> logout() async {
    try {
      await _dataSource.logout();
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stacktrace) {
      Log.error(error.toString(), error: error, stackTrace: stacktrace);
      throw BaseException();
    }
  }
}
