import 'package:flutter_demo_app/domain/domain.dart';

class DeleteCredentialUseCaseImpl implements DeleteCredentialUseCase {
  final CredentialRepository _repository;

  DeleteCredentialUseCaseImpl({
    required CredentialRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(CredentialEntity data) {
    return _repository.delete(data.objectId);
  }
}
