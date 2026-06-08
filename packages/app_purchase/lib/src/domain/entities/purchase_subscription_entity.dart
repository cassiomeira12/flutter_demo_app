import 'package:app_purchase/src/domain/entities/purchase_entity.dart';

class PurchaseSubscriptionEntity extends PurchaseEntity {
  PurchaseSubscriptionEntity({
    required super.id,
    required super.productTitle,
    required super.purchaseTitle,
    required super.purhcaseDescription,
    required super.price,
    required super.rawPrice,
    required super.currencyCode,
    required super.currencySymbol,
  });
}
