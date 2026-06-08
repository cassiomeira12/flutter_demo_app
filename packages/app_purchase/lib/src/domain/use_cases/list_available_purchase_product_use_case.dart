import 'package:app_purchase/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ListAvailablePurchaseProductUseCase
    extends BaseUseCaseAsync<List<AvailablePurchaseEntity>> {}

class ListAvailablePurchaseProductUseCaseImpl
    implements ListAvailablePurchaseProductUseCase {
  final AvailablePurchaseProductService _service;

  ListAvailablePurchaseProductUseCaseImpl({
    required AvailablePurchaseProductService availablePurchaseProductService,
  }) : _service = availablePurchaseProductService;

  @override
  Future<List<AvailablePurchaseEntity>> call() {
    return _service.list();
  }
}
