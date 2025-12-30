import 'package:dependency/dependency.dart';

class Translation extends Translations {
  static Map<String, Map<String, String>> locales = {};

  @override
  Map<String, Map<String, String>> get keys => locales;

  static Locale get fallbackLocale {
    final firstEntry = Translation().keys.entries.first;
    final List<String> split = firstEntry.key.split('_');
    final String languageCode = split.first;
    final String? countryCode = split.length > 1 ? split.last : null;
    return Locale(languageCode, countryCode);
  }

  static List<Locale> get supportedLocales {
    return Translation().keys.entries.map((entry) {
      final List<String> split = entry.key.split('_');
      final String languageCode = split.first;
      final String? countryCode = split.length > 1 ? split.last : null;
      return Locale(languageCode, countryCode);
    }).toList();
  }
}
