import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

abstract class SessionHelper {
  static Future<void> clear() async {
    try {
      final authStorageUseCase = AppBinding.find<UserAuthStorageUseCase>();

      await authStorageUseCase.clearSessionToken();
      await authStorageUseCase.clearUserData();

      AppBinding.putReplace<SessionEntity>(SessionEntity());
      AppBinding.delete<UserEntity>(force: true);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }
}
