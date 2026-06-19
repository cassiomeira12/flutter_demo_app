import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppLocaleServiceImpl implements AppLocaleService {
  final LocalStorageUseCase _localStorageUseCase;

  AppLocaleServiceImpl({required this._localStorageUseCase});

  @override
  Future<Locale?> getCurrentLocale() async {
    try {
      final String? locale = await _localStorageUseCase.get<String>(
        CURRENT_LOCALE,
      );
      if (locale != null) {
        final List<String> split = locale.split('_');
        final String languageCode = split.first;
        final String? countryCode = split.length > 1 ? split.last : null;
        return Locale(languageCode, countryCode);
      }
      return null;
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await _localStorageUseCase.set<String>(CURRENT_LOCALE, locale.toString());
  }
}
