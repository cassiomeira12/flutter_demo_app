import 'package:app_purchase/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class RestorePurchasesUseCase extends BaseUseCaseAsync<void> {}

class RestorePurchasesUseCaseImpl implements RestorePurchasesUseCase {
  final AppPurchaseService _appPurchaseService;

  RestorePurchasesUseCaseImpl({required this._appPurchaseService});

  @override
  Future<void> call() {
    return _appPurchaseService.restorePurchases();
  }
}
