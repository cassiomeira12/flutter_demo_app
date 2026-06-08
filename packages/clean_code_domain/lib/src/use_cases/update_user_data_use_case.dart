import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

abstract class UpdateUserDataUseCase
    extends BaseUseCaseAsyncParam<UserEntity, UserEntity> {}

class UpdateUserDataUseCaseImpl implements UpdateUserDataUseCase {
  final UserService _service;

  UpdateUserDataUseCaseImpl({
    required UserService userService,
  }) : _service = userService;

  @override
  Future<UserEntity> call(UserEntity user) async {
    final userUpdated = await _service.update(user.id, data: user.toMap());

    await AppBinding.replace<UserEntity>(userUpdated);

    return userUpdated;
  }
}
