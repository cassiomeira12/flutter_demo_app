import 'package:app_purchase/src/domain/domain.dart';
import 'package:dependency/dependency.dart';

abstract class AppPurchaseRepository {
  Map<String, ProductDetails> get productsDetailsMap;
  void setProductsDetails(List<ProductDetails> products);

  String? get purchaseProductId;
  void setPurchaseInProgress({String? productId});

  Stream<List<PurchaseDetailsEntity>> get userPurchases;

  PurchaseDetails? getPurchaseByProduct(String productId);
  PurchaseDetails? getPurchaseDetails(String purchaseID);
  PurchaseDetailsEntity? getPurchaseDetailsEntity(String purchaseID);

  void savePurchase(PurchaseDetails purchase);
  void removePurchase(String purchaseID);

  void updatePurchaseStatus(List<PurchaseDetails> updatePurchaseList);
}
