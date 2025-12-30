import 'package:dependency/dependency.dart';

abstract class AppPermissionsService {
  Future<PermissionStatus> checkPermission(Permission permission);

  Future<PermissionStatus> requestPermission(
    Permission permission, {
    bool openSettings = false,
  });
}
