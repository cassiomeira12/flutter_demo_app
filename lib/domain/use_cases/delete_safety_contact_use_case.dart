import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class DeleteSafetyContactUseCase
    extends BaseUseCaseAsyncParam<bool, String> {}

class DeleteSafetyContactUseCaseImpl implements DeleteSafetyContactUseCase {
  final SafetyContactService _service;

  DeleteSafetyContactUseCaseImpl({
    required SafetyContactService safetyContactService,
  }) : _service = safetyContactService;

  @override
  Future<bool> call(String objectId) {
    return _service.delete(objectId);
  }
}
