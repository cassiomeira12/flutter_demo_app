import 'package:flutter_demo_app/domain/domain.dart';

abstract class TrackLocationUseCase {
  Future<Stream<LocationEntity>> call();
}
