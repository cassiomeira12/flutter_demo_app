import 'package:flutter_demo_app/domain/domain.dart';

abstract class ListSafetyContactUseCase {
  Future<List<SafetyContactEntity>> call(int page);
}
