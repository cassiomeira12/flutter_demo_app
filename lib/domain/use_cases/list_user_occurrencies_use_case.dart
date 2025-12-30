import 'package:flutter_demo_app/domain/domain.dart';

abstract class ListUserOccurrenciesUseCase {
  Future<List<OccurrenceEntity>> call();
}
