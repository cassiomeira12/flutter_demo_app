import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class WorkPointUpdateUserDataUseCase implements UpdateUserDataUseCase {
  @override
  Future<UserEntity> call(UserEntity user) async {
    AppBinding.putReplace<UserEntity>(user);
    return user;
  }
}
