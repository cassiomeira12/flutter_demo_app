import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class ChangeNativeLocaleUseCase
    extends BaseUseCaseAsyncParam<void, Locale> {}

class ChangeNativeLocaleUseCaseImpl implements ChangeNativeLocaleUseCase {
  final ChangeLocaleNativeMethod _changeLocaleNativeMethod;

  ChangeNativeLocaleUseCaseImpl({required this._changeLocaleNativeMethod});

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
