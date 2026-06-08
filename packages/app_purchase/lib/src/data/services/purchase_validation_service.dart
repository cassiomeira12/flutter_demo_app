import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';

class PurchaseValidationServiceImpl implements PurchaseValidationService {
  @override
  Future<Result<bool>> verify({
    required String? purchaseID,
    required String productID,
    required String serverVerificationData,
  }) async {
    try {
      return const Success(true);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return Error(BaseException(error: error, stackTrace: stackTrace));
    }
  }
}
