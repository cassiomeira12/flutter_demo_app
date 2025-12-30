import 'package:dependency/dependency.dart';

abstract class UpdateLocaleUseCase {
  Future<void> call(Locale locale);
}
