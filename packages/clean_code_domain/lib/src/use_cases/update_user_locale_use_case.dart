import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class UpdateUserLocaleUseCase {
  Future<void> call(UserEntity user, {Locale? definedLocale});
}
