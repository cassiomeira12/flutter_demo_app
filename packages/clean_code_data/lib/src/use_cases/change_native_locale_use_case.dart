import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ChangeNativeLocaleUseCaseImpl implements ChangeNativeLocaleUseCase {
  final ChangeLocaleNativeMethod _changeLocaleNativeMethod;

  ChangeNativeLocaleUseCaseImpl({
    required ChangeLocaleNativeMethod changeLocaleNativeMethod,
  }) : _changeLocaleNativeMethod = changeLocaleNativeMethod;

  @override
  Future<void> call(Locale locale) async {
    try {
      return await _changeLocaleNativeMethod.call(locale);
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }
}
