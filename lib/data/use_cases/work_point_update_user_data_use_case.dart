import 'package:core/core.dart';

class WorkPointUpdateUserDataUseCase implements UpdateUserDataUseCase {
  @override
  Future<UserModel> call(UserEntity user) async {
    try {
      await AppBinding.replace<UserEntity>(user);
      return UserModel.fromMap(user.toMap());
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }
}
