import 'package:dependency/dependency.dart';

abstract class ChangeNativeLocaleUseCase {
  Future<void> call(Locale locale);
}
