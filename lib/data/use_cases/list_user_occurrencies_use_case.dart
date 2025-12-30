import 'package:flutter_demo_app/domain/domain.dart';

class ListUserOccurrenciesUseCaseImpl implements ListUserOccurrenciesUseCase {
  final EmergencyService _service;

  ListUserOccurrenciesUseCaseImpl({
    required EmergencyService emergencyService,
  }) : _service = emergencyService;

  @override
  Future<List<OccurrenceEntity>> call() {
    return _service.listHistory();
  }
}
