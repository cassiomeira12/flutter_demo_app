import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class CheckPermissionUseCaseImpl implements CheckPermissionUseCase {
  final AppPermissionsService _service;

  CheckPermissionUseCaseImpl({
    required AppPermissionsService appPermissionService,
  }) : _service = appPermissionService;

  @override
  Future<PermissionStatus> call(Permission permission) {
    return _service.checkPermission(permission);
  }
}
