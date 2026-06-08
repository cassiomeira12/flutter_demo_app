import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class WorkPointUpdateUserDataUseCase implements UpdateUserDataUseCase {
  @override
  Future<UserEntity> call(UserEntity user) async {
    try {
      await AppBinding.replace<UserEntity>(user);
      return user;
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }
}
