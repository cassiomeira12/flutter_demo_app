import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class DynamicIconUseCaseImpl implements DynamicIconUseCase {
  final _defaultIcon = const String.fromEnvironment('app_icon_apple');
  final _iconsAvailable = const String.fromEnvironment('app_icons_available');

  @override
  Future<Result<bool>> supportsAlternateIcons() async {
    try {
      final isSupported = await FlutterDynamicLauncherIcon.isSupported;
      return Success(isSupported);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return Error(BaseException(error: error, stackTrace: stackTrace));
    }
  }

  @override
  Future<Result<String>> currentIcon() async {
    final Result result = await supportsAlternateIcons();

    if (result is Error) {
      return Error(result.error);
    }

    if ((result as Success<bool>).value != true) {
      return Error(BaseException(message: 'not_supports_alternate_icons'));
    }

    try {
      final currentIcon = await FlutterDynamicLauncherIcon.alternateIconName;
      const defaultIcon = String.fromEnvironment('app_icon_apple');
      return Success(currentIcon ?? defaultIcon);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return Error(BaseException(error: error, stackTrace: stackTrace));
    }
  }

  @override
  Future<Result<void>> changeIcon(String icon) async {
    final Result result = await supportsAlternateIcons();

    if (result is Error) {
      return Error(result.error);
    }

    if ((result as Success<bool>).value != true) {
      return Error(BaseException(message: 'not_supports_alternate_icons'));
    }

    try {
      Log.info('Change Launcher icon to [$icon]');
      if (icon == _defaultIcon) return setDefaultIcon();
      await FlutterDynamicLauncherIcon.changeIcon(icon);
      Log.success('Launcher Icon was changed');
      return const Success();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return Error(BaseException(error: error, stackTrace: stackTrace));
    }
  }

  @override
  Future<Result<void>> setDefaultIcon() async {
    final Result result = await supportsAlternateIcons();

    if (result is Error) {
      return Error(result.error);
    }

    if ((result as Success<bool>).value != true) {
      return Error(BaseException(message: 'not_supports_alternate_icons'));
    }

    try {
      Log.info('Change Default Launcher icon');
      await FlutterDynamicLauncherIcon.changeIcon(null);
      Log.success('Launcher Icon was changed');
      return const Success();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return Error(BaseException(error: error, stackTrace: stackTrace));
    }
  }

  @override
  List<DynamicIcon> iconsAvailable() {
    return _iconsAvailable.split(',').map((icon) {
      return DynamicIcon(
        name: icon.trim(),
        defaultIcon: icon.trim() == _defaultIcon,
        path: 'assets/png/${icon.trim()}.png',
      );
    }).toList();
  }
}
