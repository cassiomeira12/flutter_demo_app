import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class DynamicIconUseCaseImpl implements DynamicIconUseCase {
  @override
  Future<bool> supportsAlternateIcons() async {
    try {
      return await FlutterDynamicLauncherIcon.isSupported;
    } catch (error, stackTrace) {
      Log.error(
        'Alternate Icons not supported',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<String?> currentIcon() async {
    try {
      final isSupported = await supportsAlternateIcons();
      if (!isSupported) {
        throw BaseException(message: 'Alternate Icons not supported');
      }

      return await FlutterDynamicLauncherIcon.alternateIconName;
    } catch (error, stackTrace) {
      Log.error('Get current icon', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> changeIcon(String? icon) async {
    try {
      final isSupported = await supportsAlternateIcons();
      if (!isSupported) {
        throw BaseException(message: 'Alternate Icons not supported');
      }

      Log.info('Change Launcher icon to $icon');
      await FlutterDynamicLauncherIcon.changeIcon(icon, silent: false);
      Log.success('Launcher Icon was changed');
    } catch (error, stackTrace) {
      Log.error('Change icon', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
