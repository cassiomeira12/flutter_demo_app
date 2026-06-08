import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:settings/src/domain/domain.dart';

class DynamicIconServiceImpl implements DynamicIconService {
  final String _defaultIcon;
  final String _iconsAvailable;

  DynamicIconServiceImpl({
    required this._defaultIcon,
    required this._iconsAvailable,
  });

  @override
  Future<Result<bool>> supportsAlternateIcons() async {
    try {
      final isSupported = await FlutterDynamicLauncherIcon.isSupported;
      return Success(isSupported);
    } on MissingPluginException catch (error, stackTrace) {
      return Error(BaseException(error: error, stackTrace: stackTrace));
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
  List<DynamicIconEntity> iconsAvailable() {
    try {
      return _iconsAvailable.split(',').map((icon) {
        return DynamicIconEntity(
          name: icon.trim(),
          defaultIcon: icon.trim() == _defaultIcon,
          path: 'assets/png/${icon.trim()}.png',
        );
      }).toList();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return [];
    }
  }
}
