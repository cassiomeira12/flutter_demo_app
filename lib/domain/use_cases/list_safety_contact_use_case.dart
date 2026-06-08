import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class ListSafetyContactUseCase
    extends BaseUseCaseAsyncParam<List<SafetyContactEntity>, int> {}

class ListSafetyContactUseCaseImpl implements ListSafetyContactUseCase {
  final SafetyContactService _service;

  ListSafetyContactUseCaseImpl({
    required SafetyContactService safetyContactService,
  }) : _service = safetyContactService;

  @override
  Future<List<SafetyContactEntity>> call(int page) {
    return _service.list(page);
  }
}
