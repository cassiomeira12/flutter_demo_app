import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class DeleteUserUseCaseImpl implements DeleteUserUseCase {
  final UserService _service;
  final UserAuthStorageUseCase _authStorageUseCase;

  DeleteUserUseCaseImpl({
    required UserService userService,
    required UserAuthStorageUseCase authStorageUseCase,
  }) : _service = userService,
       _authStorageUseCase = authStorageUseCase;

  @override
  Future<void> call(String reason) async {
    await _service.deleteUser(reason);

    await _authStorageUseCase.clearSessionToken();
    await _authStorageUseCase.clearUserData();

    await AppBinding.delete<SessionEntity>();
    await AppBinding.delete<UserEntity>();
  }
}
