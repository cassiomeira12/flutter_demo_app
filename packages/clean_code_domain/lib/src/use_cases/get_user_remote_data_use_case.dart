import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class GetUserRemoteDataUseCase implements BaseUseCaseAsync<UserEntity> {
  final UserService _userService;
  final UserAuthStorageUseCase _authStorageUseCase;
  final SessionEntity _sessionEntity;

  GetUserRemoteDataUseCase({
    required this._userService,
    required this._authStorageUseCase,
    required this._sessionEntity,
  });

  @override
  Future<UserEntity> call() async {
    if (_sessionEntity.isAuthenticated) {
      try {
        final user = await _userService.getUserData();
        await _authStorageUseCase.saveUserData(user);
        AppBinding.put<UserEntity>(user, permanent: true);
        return user;
      } on BaseException {
        await SessionHelper.clear();
        throw InvalidTokenException();
      }
    } else {
      throw BaseException();
    }
  }
}
