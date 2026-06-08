import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class GetCurrentLocationUseCase
    extends BaseUseCaseAsync<LocationEntity> {}

class GetCurrentLocationUseCaseImpl implements GetCurrentLocationUseCase {
  final LocationService _locationService;
  final CheckPermissionUseCase _checkPermissionUseCase;

  GetCurrentLocationUseCaseImpl({
    required this._locationService,
    required this._checkPermissionUseCase,
  });

  @override
  Future<LocationEntity> call() async {
    try {
      final permission = await _checkPermissionUseCase.call(
        Permission.location,
      );
      if (permission.isGranted) {
        return await _locationService.getCurrentLocation();
      } else {
        throw Exception();
      }
    } catch (error) {
      rethrow;
    }
  }
}
