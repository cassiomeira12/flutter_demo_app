import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class LocationServiceImpl implements LocationService {
  final _location = Location();

  @override
  Future<LocationEntity> getCurrentLocation() async {
    try {
      return await _location.getLocation().then((location) {
        return LocationEntity(
          altitude: location.altitude,
          latitude: location.latitude ?? 0,
          longitude: location.longitude ?? 0,
          accuracy: location.accuracy,
          speed: location.speed,
          date: DateTime.now(),
        );
      });
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      rethrow;
    }
  }

  @override
  Stream<LocationEntity> startTrackLocation() {
    try {
      return _location.onLocationChanged.map<LocationEntity>((location) {
        return LocationEntity(
          altitude: location.altitude,
          latitude: location.latitude ?? 0,
          longitude: location.longitude ?? 0,
          accuracy: location.accuracy,
          speed: location.speed,
          date: DateTime.now(),
        );
      });
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      rethrow;
    }
  }
}
