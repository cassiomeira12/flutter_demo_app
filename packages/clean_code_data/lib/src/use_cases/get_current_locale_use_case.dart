import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class GetCurrentLocaleUseCaseImpl implements GetCurrentLocaleUseCase {
  final AppLocaleService _appLocaleService;

  GetCurrentLocaleUseCaseImpl({required AppLocaleService appLocaleService})
    : _appLocaleService = appLocaleService;

  @override
  Future<Locale?> call() {
    return _appLocaleService.getCurrentLocale();
  }
}
