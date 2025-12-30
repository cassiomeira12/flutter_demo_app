import 'package:dependency/dependency.dart';

abstract class RequestPermissionUseCase {
  Future<PermissionStatus> call(
    Permission permission, {
    bool openSettings = false,
  });
}
