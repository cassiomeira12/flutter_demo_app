import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class GetDeviceLocaleUseCaseImpl implements GetDeviceLocaleUseCase {
  final GetDeviceInfoUseCase _getDeviceInfoUseCase;
  final GetCurrentLocaleUseCase _getCurrentLocaleUseCase;

  GetDeviceLocaleUseCaseImpl({
    required GetDeviceInfoUseCase getDeviceInfoUseCase,
    required GetCurrentLocaleUseCase getCurrentLocaleUseCase,
  }) : _getDeviceInfoUseCase = getDeviceInfoUseCase,
       _getCurrentLocaleUseCase = getCurrentLocaleUseCase;

  @override
  Future<Locale> call() async {
    try {
      final Locale? locale = await _getCurrentLocaleUseCase.call();
      if (locale != null) return locale;
      final deviceInfo = await _getDeviceInfoUseCase.call();
      if (deviceInfo.localeName == null) {
        return Translation.fallbackLocale;
      }
      Log.debug('Device Locale [${deviceInfo.localeName}]');
      final List<String> split = deviceInfo.localeName!.split('_');
      final String languageCode = split.first;
      final String? countryCode = split.length > 1 ? split.last : null;
      return Locale(languageCode, countryCode);
    } catch (_) {
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
      } catch (_) {
        return Translation.fallbackLocale;
      }
    }
  }
}
