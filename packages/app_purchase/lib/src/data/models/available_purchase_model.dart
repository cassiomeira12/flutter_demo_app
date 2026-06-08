import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';

class AvailablePurchaseModel extends AvailablePurchaseEntity {
  AvailablePurchaseModel({
    required super.id,
    required super.title,
    required super.consumableProduct,
  });

  factory AvailablePurchaseModel.fromMap(Map<String, dynamic> map) {
    try {
      return AvailablePurchaseModel(
        id: map['id'],
        title: map['title'],
        consumableProduct: map['consumableProduct'] ?? false,
      );
    } catch (error, stackTrace) {
      throw BaseException(
        error: error,
        stackTrace: stackTrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
