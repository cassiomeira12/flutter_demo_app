import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class FortressChangePasswordUseCaseImpl extends ChangePasswordUseCaseImpl {
  final CredentialRepository _credentialRepository;

  FortressChangePasswordUseCaseImpl({
    required super.userService,
    required super.userAuthStorageUseCase,
    required super.encryptUserPasswordUseCase,
    required super.encryptServerPublicKeyUseCase,
    required this._credentialRepository,
  });

  @override
  Future<void> call({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    await super.call(
      username: username,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    await _credentialRepository.refreshEncrypterKeyPassword();

    final List<CredentialEntity> list = _credentialRepository
        .valueListenable
        .value
        .map((item) => item.value)
        .toList();

    for (final item in list) {
      try {
        await _credentialRepository.update(
          item.objectId,
          data: item.toMap(),
          syncForward: false,
        );
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
      }
    }

    await _credentialRepository.forceRemoteSyncData();
  }
}
