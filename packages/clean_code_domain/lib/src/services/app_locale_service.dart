import 'package:dependency/dependency.dart';

abstract class AppLocaleService {
  Future<Locale?> getCurrentLocale();
  Future<void> setLocale(Locale locale);
}
