import 'package:core/core.dart';
import 'package:login/src/data/data.dart';
import 'package:login/src/domain/domain.dart';

class RecoveryPasswordServiceImpl implements RecoveryPasswordService {
  final RecoveryPasswordDataSource _dataSource;

  RecoveryPasswordServiceImpl({
    required RecoveryPasswordDataSource recoveryPasswordDataSource,
  }) : _dataSource = recoveryPasswordDataSource;

  @override
  Future<void> recoveryPassword(String email) async {
    try {
      await _dataSource.recoveryPassword(email);
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stacktrace) {
      Log.error(error.toString(), error: error, stackTrace: stacktrace);
      throw BaseException();
    }
  }
}
