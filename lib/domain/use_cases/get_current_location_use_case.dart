import 'package:flutter_demo_app/domain/domain.dart';

abstract class GetCurrentLocationUseCase {
  Future<LocationEntity> call();
}
