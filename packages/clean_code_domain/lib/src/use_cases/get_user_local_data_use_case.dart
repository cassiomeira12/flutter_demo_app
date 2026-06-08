import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class GetUserLocalDataUseCase implements BaseUseCaseAsync<UserEntity> {
  final UserAuthStorageUseCase _authStorageUseCase;
  final SessionEntity _sessionEntity;

  GetUserLocalDataUseCase({
    required this._authStorageUseCase,
    required this._sessionEntity,
  });

  @override
  Future<UserEntity> call() async {
    if (_sessionEntity.isAuthenticated) {
      final localUser = await _authStorageUseCase.getUserData();
      if (localUser == null) throw BaseException();
      AppBinding.put<UserEntity>(localUser, permanent: true);
      return localUser;
    } else {
      throw BaseException();
    }
  }
}
