import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class TrackLocationUseCase
    extends BaseUseCaseAsync<Stream<LocationEntity>> {}

class TrackLocationUseCaseImpl implements TrackLocationUseCase {
  final LocationService _locationService;
  final CheckPermissionUseCase _checkPermissionUseCase;

  TrackLocationUseCaseImpl({
    required this._locationService,
    required this._checkPermissionUseCase,
  });

  @override
  Future<Stream<LocationEntity>> call() async {
    try {
      final permission = await _checkPermissionUseCase.call(
        Permission.location,
      );
      if (permission.isGranted) {
        return _locationService.startTrackLocation();
      } else {
        throw Exception();
      }
    } catch (error) {
      rethrow;
    }
  }
}
