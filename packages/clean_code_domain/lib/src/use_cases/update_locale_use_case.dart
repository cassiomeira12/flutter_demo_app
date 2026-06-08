import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class UpdateLocaleUseCase
    extends BaseUseCaseAsyncParam<void, Locale> {}

class UpdateLocaleUseCaseImpl implements UpdateLocaleUseCase {
  final AppLocaleService _appLocaleService;
  final ChangeNativeLocaleUseCase _changeNativeLocaleUseCase;

  UpdateLocaleUseCaseImpl({
    required this._appLocaleService,
    required this._changeNativeLocaleUseCase,
  });

  @override
  Future<void> call(Locale locale) async {
    await Get.updateLocale(locale);
    await _changeNativeLocaleUseCase.call(locale);
    await _appLocaleService.setLocale(locale);
  }
}
