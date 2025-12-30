import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class TrackLocationUseCaseImpl implements TrackLocationUseCase {
  final LocationService _service;
  final CheckPermissionUseCase _checkPermissionUseCase;

  TrackLocationUseCaseImpl({
    required LocationService locationService,
    required CheckPermissionUseCase checkPermissionUseCase,
  }) : _service = locationService,
       _checkPermissionUseCase = checkPermissionUseCase;

  @override
  Future<Stream<LocationEntity>> call() async {
    try {
      final permission = await _checkPermissionUseCase.call(
        Permission.location,
      );
      if (permission.isGranted) {
        return _service.startTrackLocation();
      } else {
        throw Exception();
      }
    } catch (error) {
      rethrow;
    }
  }
}
