import 'package:flutter_demo_app/domain/domain.dart';

class DeleteCredentialUseCaseImpl implements DeleteCredentialUseCase {
  final CredentialService _service;

  DeleteCredentialUseCaseImpl({
    required CredentialService service,
  }) : _service = service;

  @override
  Future<void> call(CredentialEntity data) {
    return _service.delete(data.objectId);
  }
}
