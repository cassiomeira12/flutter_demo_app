import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CredentialsStore {
  final CredentialRepository _repository;

  CredentialsStore({
    required CredentialRepository credentialRepository,
  }) : _repository = credentialRepository;

  Rxn<CredentialEntity> credential = Rxn();

  List<ValueNotifier> get credentials => _repository.valueListenable.value;

  int indexOf(String objectId) {
    return _repository.valueListenable.value.indexWhere((item) {
      return credential.value?.objectId == item.value.objectId;
    });
  }
}
