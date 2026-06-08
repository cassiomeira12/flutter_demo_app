import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class GetDeviceLocaleUseCase extends BaseUseCaseAsync<Locale> {}

class GetDeviceLocaleUseCaseImpl implements GetDeviceLocaleUseCase {
  final GetDeviceInfoUseCase _getDeviceInfoUseCase;
  final GetCurrentLocaleUseCase _getCurrentLocaleUseCase;

  GetDeviceLocaleUseCaseImpl({
    required this._getDeviceInfoUseCase,
    required this._getCurrentLocaleUseCase,
  });

  @override
  Future<Locale> call() async {
    try {
      final results = await Future.wait([
        _getCurrentLocaleUseCase.call(),
        _getDeviceInfoUseCase.call(),
      ]);
      final Locale? locale = results.first as Locale?;
      if (locale != null) return locale;
      final DeviceInfoEntity deviceInfo = results.last! as DeviceInfoEntity;
      if (deviceInfo.localeName == null) {
        return Translation.fallbackLocale;
      }
      Log.debug('Device Locale [${deviceInfo.localeName}]');
      final List<String> split = deviceInfo.localeName!.split('_');
      final String languageCode = split.first;
      final String? countryCode = split.length > 1 ? split.last : null;
      return Locale(languageCode, countryCode);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      try {
        final deviceInfo = await _getDeviceInfoUseCase.call();
        if (deviceInfo.localeName == null) {
          return Translation.fallbackLocale;
        }
        Log.info('Device Locale [${deviceInfo.localeName}]');
        final List<String> split = deviceInfo.localeName!.split('_');
        final String languageCode = split.first;
        final String? countryCode = split.length > 1 ? split.last : null;
        return Locale(languageCode, countryCode);
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
        return Translation.fallbackLocale;
      }
    }
  }
}
