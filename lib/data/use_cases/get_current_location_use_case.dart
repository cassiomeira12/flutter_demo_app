import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class GetCurrentLocationUseCaseImpl implements GetCurrentLocationUseCase {
  final LocationService _service;
  final CheckPermissionUseCase _checkPermissionUseCase;

  GetCurrentLocationUseCaseImpl({
    required LocationService locationService,
    required CheckPermissionUseCase checkPermissionUseCase,
  }) : _service = locationService,
       _checkPermissionUseCase = checkPermissionUseCase;

  @override
  Future<LocationEntity> call() async {
    try {
      final permission = await _checkPermissionUseCase.call(
        Permission.location,
      );
      if (permission.isGranted) {
        return await _service.getCurrentLocation();
      } else {
        throw Exception();
      }
    } catch (error) {
      rethrow;
    }
  }
}
