import 'package:core/core.dart';

class WorkPointUpdateUserDataUseCase implements UpdateUserDataUseCase {
  @override
  Future<UserModel> call(UserEntity user) async {
    await AppBinding.replace<UserEntity>(user);

    return UserModel.fromMap(user.toMap());
  }
}
