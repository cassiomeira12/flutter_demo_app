import 'package:app_purchase/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class BuyPurchaseSubscriptionUseCase
    extends BaseUseCaseAsyncParam<void, PurchaseSubscriptionEntity> {}

class BuyPurchaseSubscriptionUseCaseImpl
    implements BuyPurchaseSubscriptionUseCase {
  final AppPurchaseService _appPurchaseService;

  BuyPurchaseSubscriptionUseCaseImpl({required this._appPurchaseService});

  @override
  Future<void> call(PurchaseSubscriptionEntity subcription) {
    return _appPurchaseService.buySubscription(subcription);
  }
}
