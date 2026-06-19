import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

abstract class UpdateUserDataUseCase
    extends BaseUseCaseAsyncParam<UserEntity, UserEntity> {}

class UpdateUserDataUseCaseImpl implements UpdateUserDataUseCase {
  final UserService _userService;

  UpdateUserDataUseCaseImpl({required this._userService});

  @override
  Future<UserEntity> call(UserEntity user) async {
    final userUpdated = await _userService.update(user.id, data: user.toMap());

    AppBinding.putReplace<UserEntity>(userUpdated);

    return userUpdated;
  }
}
