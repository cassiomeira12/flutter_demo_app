import 'package:flutter_demo_app/domain/domain.dart';

abstract class LocationService {
  Future<LocationEntity> getCurrentLocation();

  Stream<LocationEntity> startTrackLocation();
}
