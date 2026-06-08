import 'package:app_purchase/src/domain/entities/entities.dart';

class PurchaseProductModel extends PurchaseProductEntity {
  PurchaseProductModel({
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
