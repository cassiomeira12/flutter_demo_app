import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class CheckPermissionUseCase
    extends BaseUseCaseAsyncParam<PermissionStatus, Permission> {}

class CheckPermissionUseCaseImpl implements CheckPermissionUseCase {
  final AppPermissionsService _appPermissionService;

  CheckPermissionUseCaseImpl({required this._appPermissionService});

  @override
  Future<PermissionStatus> call(Permission permission) {
    return _appPermissionService.checkPermission(permission);
  }
}
