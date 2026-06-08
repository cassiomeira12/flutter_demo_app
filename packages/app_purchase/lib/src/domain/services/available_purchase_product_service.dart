import 'package:app_purchase/src/domain/domain.dart';

abstract class AvailablePurchaseProductService {
  Future<List<AvailablePurchaseEntity>> list();
}
