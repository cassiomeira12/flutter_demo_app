import 'package:app_purchase/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ListPurchaseProductsUseCase
    extends
        BaseUseCaseAsyncParam<
          List<PurchaseEntity>,
          List<AvailablePurchaseEntity>
        > {}

class ListPurchaseProductsUseCaseImpl implements ListPurchaseProductsUseCase {
  final AppPurchaseService _service;

  ListPurchaseProductsUseCaseImpl({
    required AppPurchaseService appPurchaseService,
  }) : _service = appPurchaseService;

  @override
  Future<List<PurchaseEntity>> call(
    List<AvailablePurchaseEntity> products,
  ) {
    return _service.queryProductDetails(products);
  }
}
