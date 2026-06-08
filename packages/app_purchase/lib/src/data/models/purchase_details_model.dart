import 'package:app_purchase/src/domain/domain.dart';

class PurchaseDetailsModel extends PurchaseDetailsEntity {
  PurchaseDetailsModel({
    required super.objectId,
    required super.createdAt,
    required super.updatedAt,
    required super.purchaseID,
    required super.productId,
    required super.source,
    required super.localVerificationData,
    required super.serverVerificationData,
    required super.prouctPrice,
    required super.cancelled,
  });
}
