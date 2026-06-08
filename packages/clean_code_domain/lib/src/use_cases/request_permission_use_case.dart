import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class RequestPermissionUseCase extends UseCase {
  Future<PermissionStatus> call(
    Permission permission, {
    bool openSettings = false,
  });
}

class RequestPermissionUseCaseImpl implements RequestPermissionUseCase {
  final AppPermissionsService _service;

  RequestPermissionUseCaseImpl({
    required AppPermissionsService appPermissionService,
  }) : _service = appPermissionService;

  @override
  Future<PermissionStatus> call(
    Permission permission, {
    bool openSettings = false,
  }) {
    return _service.requestPermission(permission, openSettings: openSettings);
  }
}
