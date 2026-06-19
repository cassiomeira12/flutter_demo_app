import 'package:core/core.dart';
import 'package:login/src/data/data.dart';
import 'package:login/src/domain/domain.dart';

class RecoveryPasswordServiceImpl implements RecoveryPasswordService {
  final RecoveryPasswordDataSource _recoveryPasswordDataSource;

  RecoveryPasswordServiceImpl({required this._recoveryPasswordDataSource});

  @override
  Future<void> recoveryPassword(String email) async {
    try {
      await _recoveryPasswordDataSource.recoveryPassword(email);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      throw BaseException(
        message: 'recoveryPassword',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
