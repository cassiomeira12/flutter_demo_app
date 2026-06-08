import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class GetLocalContactUseCase
    extends BaseUseCaseAsync<LocalContactEntity> {}

class GetLocalContactUseCaseImpl implements GetLocalContactUseCase {
  final ContactService _contactService;

  GetLocalContactUseCaseImpl({
    required this._contactService,
  });

  @override
  Future<LocalContactEntity> call() {
    return _contactService.getContact();
  }
}
