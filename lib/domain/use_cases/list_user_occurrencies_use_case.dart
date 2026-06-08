import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class ListUserOccurrenciesUseCase
    extends BaseUseCaseAsync<List<OccurrenceEntity>> {}

class ListUserOccurrenciesUseCaseImpl implements ListUserOccurrenciesUseCase {
  final EmergencyService _emergencyService;

  ListUserOccurrenciesUseCaseImpl({required this._emergencyService});

  @override
  Future<List<OccurrenceEntity>> call() {
    return _emergencyService.listHistory();
  }
}
