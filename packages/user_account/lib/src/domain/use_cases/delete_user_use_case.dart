import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

abstract class DeleteUserUseCase extends BaseUseCaseAsyncParam<void, String> {}

class DeleteUserUseCaseImpl implements DeleteUserUseCase {
  final UserService _userService;
  final UserAuthStorageUseCase _authStorageUseCase;

  DeleteUserUseCaseImpl({
    required this._userService,
    required this._authStorageUseCase,
  });

  @override
  Future<void> call(String reason) async {
    await _userService.deleteUser(reason);

    await _authStorageUseCase.clearSessionToken();
    await _authStorageUseCase.clearUserData();

    await AppBinding.delete<SessionEntity>();
    await AppBinding.delete<UserEntity>();
  }
}
