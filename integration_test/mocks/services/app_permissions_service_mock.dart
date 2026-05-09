import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppPermissionsServiceMock extends Mock implements AppPermissionsService {
  final Map<Permission, PermissionStatus> _status;

  AppPermissionsServiceMock({
    required Map<Permission, PermissionStatus> status,
  }) : _status = status;

  @override
  Future<PermissionStatus> checkPermission(Permission permission) async {
    return _status[permission] ?? PermissionStatus.denied;
  }

  @override
  Future<PermissionStatus> requestPermission(
    Permission permission, {
    bool openSettings = false,
  }) async {
    if (_status[permission] == PermissionStatus.permanentlyDenied) {
      return _status[permission]!;
    }

    final bool? result = await DialogWidget.showChoice(
      Get.context!,
      title: 'Request Permission',
      message: permission.toString(),
      okButton: 'allow'.tr,
      cancelButton: 'allow_later'.tr,
    );

    if (result == true) {
      _status[permission] = PermissionStatus.granted;
    } else {
      _status[permission] = PermissionStatus.permanentlyDenied;
    }

    return _status[permission] ?? PermissionStatus.permanentlyDenied;
  }
}
