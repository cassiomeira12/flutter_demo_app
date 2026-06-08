import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class DeleteCredentialUseCase
    extends BaseUseCaseAsyncParam<void, CredentialEntity> {}

class DeleteCredentialUseCaseImpl implements DeleteCredentialUseCase {
  final CredentialRepository _repository;

  DeleteCredentialUseCaseImpl({
    required this._repository,
  });

  @override
  Future<void> call(CredentialEntity data) {
    return _repository.delete(data.objectId);
  }
}
