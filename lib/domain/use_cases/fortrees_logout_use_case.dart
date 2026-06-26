import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class FortreesLogoutUseCaseImpl extends LogoutUseCaseImpl {
  final CredentialRepository _credentialRepository;

  FortreesLogoutUseCaseImpl({
    required super.logoutService,
    required this._credentialRepository,
  });

  @override
  Future<void> call() async {
    await super.call();
    await _credentialRepository.deleteLocalDatabase();
  }
}
