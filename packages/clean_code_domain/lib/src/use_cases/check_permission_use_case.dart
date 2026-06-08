import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class CheckPermissionUseCase
    extends BaseUseCaseAsyncParam<PermissionStatus, Permission> {}

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
