import 'package:flutter_demo_app/domain/domain.dart';

class GetLocalContactUseCaseImpl implements GetLocalContactUseCase {
  final ContactService _service;

  GetLocalContactUseCaseImpl({
    required ContactService contactService,
  }) : _service = contactService;

  @override
  Future<LocalContactEntity> call() {
    return _service.getContact();
  }
}
