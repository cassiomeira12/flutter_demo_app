import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class GetCurrentLocaleUseCase extends BaseUseCaseAsync<Locale?> {}

class GetCurrentLocaleUseCaseImpl implements GetCurrentLocaleUseCase {
  final AppLocaleService _service;

  GetCurrentLocaleUseCaseImpl({
    required AppLocaleService appLocaleService,
  }) : _service = appLocaleService;

  @override
  Future<Locale?> call() {
    return _service.getCurrentLocale();
  }
}
