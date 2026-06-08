import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

mixin LogPurchaseMixin {
  void logPurchaseEntity(PurchaseEntity product) {
    Log.info(
      'Product Details \n'
      'id: ${product.id} \n'
      'productTitle: ${product.title} \n'
      'purchaseTitle: ${product.purchaseTitle} \n'
      'consumable: ${product is PurchaseProductEntity} \n'
      'purhcaseDescription: ${product.purhcaseDescription} \n'
      'price: ${product.price} \n'
      'rawPrice: ${product.rawPrice} \n'
      'currencyCode: ${product.currencyCode} \n'
      'currencySymbol: ${product.currencySymbol} \n',
    );
  }

  void logPurchaseProductEntity(
    PurchaseEntity product,
    String? userIdentifierId,
  ) {
    Log.debug(
      '$runtimeType.buy for user: $userIdentifierId \n'
      'id: ${product.id} \n'
      'productTitle: ${product.title} \n'
      'purchaseTitle: ${product.purchaseTitle} \n'
      'consumable: ${product is PurchaseProductEntity} \n'
      'purhcaseDescription: ${product.purhcaseDescription} \n'
      'price: ${product.price} \n'
      'rawPrice: ${product.rawPrice} \n'
      'currencyCode: ${product.currencyCode} \n'
      'currencySymbol: ${product.currencySymbol} \n',
    );
  }

  void logPurchase(PurchaseDetails purchase) {
    Log.info(
      'PurchaseDetails ${purchase.runtimeType} [${purchase.status.name.toUpperCase()}] \n'
      'purchaseID: ${purchase.purchaseID} \n'
      'productID: ${purchase.productID} \n'
      'transactionDate: ${purchase.transactionDate} \n'
      'pendingCompletePurchase: [${purchase.pendingCompletePurchase}] \n'
      'error: ${purchase.error}',
    );
  }
}
