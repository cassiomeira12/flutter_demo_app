import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:login/src/domain/domain.dart';

abstract class CreateUserUseCase extends UseCase {
  Future<UserEntity> call({
    required String name,
    required String email,
    required String username,
    required String password,
  });
}

class CreateUserUseCaseImpl implements CreateUserUseCase {
  final SignupService _singUpService;
  final UserAuthStorageUseCase _authStorageUseCase;
  final UserService _userService;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final EncryptServerPublicKeyUseCase _encryptServerPublicKeyUseCase;

  CreateUserUseCaseImpl({
    required this._singUpService,
    required this._authStorageUseCase,
    required this._userService,
    required this._encryptUserPasswordUseCase,
    required this._encryptServerPublicKeyUseCase,
  });

  @override
  Future<UserEntity> call({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final encryptedPassword = _encryptServerPublicKeyUseCase.call(password);

      final Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'username': username,
        'password': encryptedPassword,
      };

      final user = await _singUpService.create(data);

      final String sessionToken = user.sessionToken!;
      final session = SessionEntity(token: sessionToken);

      AppBinding.putReplace<SessionEntity>(session);
      AppBinding.put<UserEntity>(user, permanent: true);

      await _encryptUserPasswordUseCase.encrypt(password: password);

      await _authStorageUseCase.saveSessionToken(sessionToken);
      await _authStorageUseCase.saveUserData(user);

      await _userService.getUserData();

      return user;
    } catch (error) {
      await SessionHelper.clear();
      rethrow;
    }
  }
}
