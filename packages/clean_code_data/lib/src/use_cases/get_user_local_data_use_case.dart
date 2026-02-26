import 'package:core/core.dart';

class GetUserLocalDataUseCaseImpl implements GetUserDataUseCase {
  final UserAuthStorageUseCase _authStorageUseCase;
  final SessionEntity _sessionEntity;

  GetUserLocalDataUseCaseImpl({
    required UserAuthStorageUseCase authStorageUseCase,
    required SessionEntity sessionEntity,
  }) : _authStorageUseCase = authStorageUseCase,
       _sessionEntity = sessionEntity;

  @override
  Future<UserModel> call() async {
    if (_sessionEntity.isAuthenticated) {
      final localUser = await _authStorageUseCase.getUserData();
      if (localUser == null) throw BaseException();
      final UserModel user = UserModel.fromMap(localUser);
      AppBinding.put<UserEntity>(user, permanent: true);
      return user;
    } else {
      throw BaseException();
    }
  }
}
