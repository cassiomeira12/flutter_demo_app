import 'package:core/core.dart';
import 'package:login/src/domain/domain.dart';

class CreateUserUseCaseImpl implements CreateUserUseCase {
  final SignupService _singupService;
  final UserAuthStorageUseCase _authStorageUseCase;
  final UserService _userService;
  final EncryptUserPasswordUseCase _encrypterUserPasswordUseCase;
  final EncryptServerPublicKeyUseCase _encryptServerUseCase;

  CreateUserUseCaseImpl({
    required SignupService signupService,
    required UserAuthStorageUseCase authStorageUseCase,
    required UserService userService,
    required EncryptUserPasswordUseCase encrypterUserPasswordUseCase,
    required EncryptServerPublicKeyUseCase encryptServerPublicKeyUseCase,
  }) : _singupService = signupService,
       _authStorageUseCase = authStorageUseCase,
       _userService = userService,
       _encrypterUserPasswordUseCase = encrypterUserPasswordUseCase,
       _encryptServerUseCase = encryptServerPublicKeyUseCase;

  @override
  Future<UserModel> call({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    final encryptedPassword = _encryptServerUseCase.call(password);

    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'username': username,
      'password': encryptedPassword,
    };

    final user = await _singupService.create(data);

    final String sessionToken = user.sessionToken!;
    final session = SessionEntity(token: sessionToken);

    await AppBinding.replace<SessionEntity>(session);
    AppBinding.put<UserEntity>(user, permanent: true);

    await _encrypterUserPasswordUseCase.encrypt(password: password);

    await _authStorageUseCase.saveSessionToken(sessionToken);
    await _authStorageUseCase.saveUserData(user.toMap());

    await _userService.getUserData();

    return user as UserModel;
  }
}
