import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class FortressDeleteUserUseCaseImpl extends DeleteUserUseCaseImpl {
  final CredentialRepository _credentialRepository;

  FortressDeleteUserUseCaseImpl({
    required super.userService,
    required super.authStorageUseCase,
    required this._credentialRepository,
  });

  @override
  Future<void> call(String reason) async {
    await super.call(reason);
    await _credentialRepository.deleteLocalDatabase();
  }
}
