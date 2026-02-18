import 'package:core/core.dart';

class UpdateUserDataUseCaseImpl implements UpdateUserDataUseCase {
  final UserService _service;

  UpdateUserDataUseCaseImpl({required UserService userService})
    : _service = userService;

  @override
  Future<UserModel> call(UserEntity user) async {
    final userUpdated = await _service.update(user.id, data: user.toMap());

    await AppBinding.replace<UserEntity>(userUpdated);

    return userUpdated as UserModel;
  }
}
