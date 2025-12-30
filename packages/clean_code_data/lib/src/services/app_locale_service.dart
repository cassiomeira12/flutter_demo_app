import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppLocaleServiceImpl implements AppLocaleService {
  final LocalStorageUseCase _localStorage;

  AppLocaleServiceImpl({required LocalStorageUseCase localStorageUseCase})
    : _localStorage = localStorageUseCase;

  @override
  Future<Locale?> getCurrentLocale() async {
    try {
      final String? locale = await _localStorage.get<String>(CURRENT_LOCALE);
      if (locale != null) {
        final List<String> split = locale.split('_');
        final String languageCode = split.first;
        final String? countryCode = split.length > 1 ? split.last : null;
        return Locale(languageCode, countryCode);
      }
      return null;
    } catch (error, stacktrace) {
      Log.error('Unexpected Exception', error: error, stackTrace: stacktrace);
      rethrow;
    }
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await _localStorage.set<String>(CURRENT_LOCALE, locale.toString());
  }
}
