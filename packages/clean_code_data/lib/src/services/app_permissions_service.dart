import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppPermissionsServiceImpl implements AppPermissionsService {
  PermissionStatus parseStatus(String status) {
    switch (status) {
      case 'granted':
        return PermissionStatus.granted;
      case 'grantedLimited':
        return PermissionStatus.limited;
      case 'denied':
        return PermissionStatus.denied;
      case 'deniedForever':
      default:
        return PermissionStatus.permanentlyDenied;
    }
  }

  @override
  Future<PermissionStatus> checkPermission(Permission permission) async {
    try {
      switch (permission) {
        case Permission.location:
          final locationService = Location();
          final status = await locationService.hasPermission();
          return parseStatus(status.name);
        default:
          return await permission.status;
      }
    } on MissingPluginException catch (error, stacktrace) {
      if (permission == Permission.notification) {
        // ignore exception notification on macos
        if (Platform.isMacOS) {
          return PermissionStatus.permanentlyDenied;
        }
      }
      Log.error('Unexpected Exception', error: error, stackTrace: stacktrace);
      rethrow;
    } catch (error, stacktrace) {
      Log.error('Unexpected Exception', error: error, stackTrace: stacktrace);
      rethrow;
    }
  }

  @override
  Future<PermissionStatus> requestPermission(
    Permission permission, {
    bool openSettings = false,
  }) async {
    try {
      switch (permission) {
        case Permission.location:
          final locationService = Location();
          var enabled = await locationService.serviceEnabled();
          if (!enabled) {
            enabled = await locationService.requestService();
            if (!enabled) {
              return PermissionStatus.denied;
            }
          }
          final status = await locationService.requestPermission();
          return parseStatus(status.name);
        case Permission.notification:
          final status = await checkPermission(permission);
          if (status.isPermanentlyDenied && openSettings) {
            await openAppSettings();
          }
          return await permission.request();
        default:
          return await permission.request();
      }
    } on MissingPluginException catch (error, stacktrace) {
      if (permission == Permission.notification) {
        // ignore exception notification on macos
        if (Platform.isMacOS) {
          return PermissionStatus.permanentlyDenied;
        }
      }
      Log.error('Unexpected Exception', error: error, stackTrace: stacktrace);
      rethrow;
    } catch (error, stacktrace) {
      Log.error('Unexpected Exception', error: error, stackTrace: stacktrace);
      rethrow;
    }
  }
}
