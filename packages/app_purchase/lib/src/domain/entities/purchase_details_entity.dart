import 'package:clean_code_domain/clean_code_domain.dart';

class PurchaseDetailsEntity extends BaseEntity {
  final String? purchaseID;
  final String productId;
  final String source;
  final String localVerificationData;
  final String serverVerificationData;
  final String prouctPrice;

  final bool cancelled;

  PurchaseDetailsEntity({
    required super.objectId,
    required super.createdAt,
    required super.updatedAt,
    required this.purchaseID,
    required this.productId,
    required this.source,
    required this.localVerificationData,
    required this.serverVerificationData,
    required this.prouctPrice,
    required this.cancelled,
  });

  @override
  PurchaseDetailsEntity copyWith({
    String? objectId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? purchaseID,
    String? productId,
    String? source,
    String? localVerificationData,
    String? serverVerificationData,
    String? prouctPrice,
    bool? cancelled,
  }) {
    return PurchaseDetailsEntity(
      objectId: objectId ?? this.objectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      purchaseID: purchaseID ?? this.purchaseID,
      productId: productId ?? this.productId,
      source: source ?? this.source,
      localVerificationData:
          localVerificationData ?? this.localVerificationData,
      serverVerificationData:
          serverVerificationData ?? this.serverVerificationData,
      prouctPrice: prouctPrice ?? this.prouctPrice,
      cancelled: cancelled ?? this.cancelled,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'purchaseID': purchaseID,
      'productId': productId,
      'source': source,
      'localVerificationData': localVerificationData,
      'serverVerificationData': serverVerificationData,
      'prouctPrice': prouctPrice,
      'cancelled': cancelled,
    };
  }
}
