import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class UpdateLocaleUseCaseImpl implements UpdateLocaleUseCase {
  final AppLocaleService _appLocaleService;
  final ChangeNativeLocaleUseCase _changeNativeLocaleUseCase;

  UpdateLocaleUseCaseImpl({
    required AppLocaleService appLocaleService,
    required ChangeNativeLocaleUseCase changeNativeLocaleUseCase,
  }) : _appLocaleService = appLocaleService,
       _changeNativeLocaleUseCase = changeNativeLocaleUseCase;

  @override
  Future<void> call(Locale locale) async {
    await Get.updateLocale(locale);
    await _changeNativeLocaleUseCase.call(locale);
    await _appLocaleService.setLocale(locale);
  }
}
