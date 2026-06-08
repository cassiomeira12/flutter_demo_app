import 'package:core/core.dart';

abstract class PurchaseValidationService {
  Future<Result<bool>> verify({
    required String? purchaseID,
    required String productID,
    required String serverVerificationData,
  });
}
