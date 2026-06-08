import 'package:app_purchase/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class CheckPurchaseAvailableUseCase extends BaseUseCaseAsync<void> {}

class CheckPurchaseAvailableUseCaseImpl
    implements CheckPurchaseAvailableUseCase {
  final AppPurchaseService _service;

  CheckPurchaseAvailableUseCaseImpl({
    required AppPurchaseService appPurchaseService,
  }) : _service = appPurchaseService;

  @override
  Future<bool> call() {
    return _service.isServiceAvailable();
  }
}
