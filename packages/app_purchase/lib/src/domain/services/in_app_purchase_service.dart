import 'package:dependency/dependency.dart';

abstract class InAppPurchaseService {
  Stream<List<PurchaseDetails>> get purchaseStream;

  Future<bool> isAvailable();

  Future<bool> buyConsumable(PurchaseParam param);

  Future<bool> buyNonConsumable(PurchaseParam param);

  Future<void> restorePurchases(String userIdentifierId);

  Future<void> completePurchase(PurchaseDetails purchase);

  Future<ProductDetailsResponse> queryProducts(List<String> ids);
}
