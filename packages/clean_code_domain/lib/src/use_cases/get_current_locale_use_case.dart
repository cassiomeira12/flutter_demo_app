import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class GetCurrentLocaleUseCase extends BaseUseCaseAsync<Locale?> {}

class GetCurrentLocaleUseCaseImpl implements GetCurrentLocaleUseCase {
  final AppLocaleService _appLocaleService;

  GetCurrentLocaleUseCaseImpl({required this._appLocaleService});

  @override
  Future<Locale?> call() {
    return _appLocaleService.getCurrentLocale();
  }
}
