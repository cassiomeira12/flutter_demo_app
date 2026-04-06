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
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }
}
