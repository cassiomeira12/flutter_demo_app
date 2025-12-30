import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ChangeNativeLocaleUseCaseImpl implements ChangeNativeLocaleUseCase {
  final ChangeLocaleNativeMethod _nativeMethod;

  ChangeNativeLocaleUseCaseImpl({
    required ChangeLocaleNativeMethod changeLocaleNativeMethod,
  }) : _nativeMethod = changeLocaleNativeMethod;

  @override
  Future<void> call(Locale locale) {
    return _nativeMethod.call(locale);
  }
}
