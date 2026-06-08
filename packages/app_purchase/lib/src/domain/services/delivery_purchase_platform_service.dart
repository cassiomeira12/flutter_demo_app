import 'package:dependency/dependency.dart';

abstract class DeliveryPurchasePlatformService {
  Future<void> finishPurchase(PurchaseDetails purchase);
}
