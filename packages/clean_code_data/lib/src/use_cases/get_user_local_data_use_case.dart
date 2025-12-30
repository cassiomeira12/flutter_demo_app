import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class GetUserLocalDataUseCaseImpl implements GetUserDataUseCase {
  final UserAuthStorageUseCase _authStorageUseCase;

  GetUserLocalDataUseCaseImpl({
    required UserAuthStorageUseCase authStorageUseCase,
  }) : _authStorageUseCase = authStorageUseCase;

  @override
  Future<UserModel> call() async {
    if (!AppBinding.hasInstance<SessionEntity>()) {
      throw BaseException();
    }
    final session = AppBinding.find<SessionEntity>();
    if (session.token != null) {
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
