import 'package:app_purchase/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class BuyPurchaseProductUseCase
    extends BaseUseCaseAsyncParam<void, PurchaseProductEntity> {}

class BuyPurchaseProductUseCaseImpl implements BuyPurchaseProductUseCase {
  final AppPurchaseService _service;

  BuyPurchaseProductUseCaseImpl({
    required AppPurchaseService appPurchaseService,
  }) : _service = appPurchaseService;

  @override
  Future<void> call(PurchaseProductEntity product) {
    return _service.buyProduct(product);
  }
}
