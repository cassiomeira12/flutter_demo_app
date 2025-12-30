import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class GetUserDataUseCaseImpl implements GetUserDataUseCase {
  final UserService _repository;
  final UserAuthStorageUseCase _authStorageUseCase;

  GetUserDataUseCaseImpl({
    required UserService userService,
    required UserAuthStorageUseCase authStorageUseCase,
  }) : _repository = userService,
       _authStorageUseCase = authStorageUseCase;

  @override
  Future<UserModel> call() async {
    if (!AppBinding.hasInstance<SessionEntity>()) {
      throw BaseException();
    }
    final session = AppBinding.find<SessionEntity>();
    if (session.token != null) {
      try {
        final user = await _repository.getUserData();
        await _authStorageUseCase.saveUserData(user.toMap());
        AppBinding.put<UserEntity>(user, permanent: true);
        return user as UserModel;
      } on BaseException {
        await SessionHelper.clear();
        throw InvalidTokenException();
      }
    } else {
      throw BaseException();
    }
  }
}
