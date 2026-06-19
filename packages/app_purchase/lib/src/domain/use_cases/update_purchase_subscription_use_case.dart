import 'package:app_purchase/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class UpdatePurchaseSubscriptionUseCase extends UseCase {
  Future<void> call({
    required PurchaseDetailsEntity oldSubscription,
    required PurchaseSubscriptionEntity newSubscription,
  });
}

class UpdatePurchaseSubscriptionUseCaseImpl
    implements UpdatePurchaseSubscriptionUseCase {
  final AppPurchaseService _appPurchaseService;

  UpdatePurchaseSubscriptionUseCaseImpl({required this._appPurchaseService});

  @override
  Future<void> call({
    required PurchaseDetailsEntity oldSubscription,
    required PurchaseSubscriptionEntity newSubscription,
  }) {
    return _appPurchaseService.updateSubscription(
      oldSubscription: oldSubscription,
      newSubscription: newSubscription,
    );
  }
}
