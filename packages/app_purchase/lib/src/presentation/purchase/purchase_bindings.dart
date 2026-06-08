import 'package:app_purchase/src/data/data.dart';
import 'package:app_purchase/src/data/services/future_completer_manager.dart';
import 'package:app_purchase/src/domain/domain.dart';
import 'package:app_purchase/src/infra/data_sources/data_sources.dart';
import 'package:app_purchase/src/presentation/purchase/purchase.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class PurchaseBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<AvailablePurchaseProductDataSource>(
      AvailablePurchaseProductDataSourceImpl(),
    );

    AppBinding.put<AvailablePurchaseProductService>(
      AvailablePurchaseProductServiceImpl(
        availablePurchaseProductDataSource: AppBinding.find(),
      ),
    );
    AppBinding.put<PurchaseValidationService>(
      PurchaseValidationServiceImpl(),
    );

    AppBinding.put<AppPurchaseRepository>(
      AppPurchaseRepositoryImpl(),
    );

    AppBinding.put<InAppPurchaseService>(
      InAppPurchaseServiceImpl(),
    );

    AppBinding.put<FutureCompleterManager>(
      FutureCompleterManager(),
    );

    if (Platform.isAndroid) {
      AppBinding.put<DeliveryPurchasePlatformService>(
        DeliveryPurchaseAndroidService(
          appPurchaseRepository: AppBinding.find(),
          futureCompleterManager: AppBinding.find(),
        ),
      );
    }

    if (Platform.appleDevice) {
      AppBinding.put<DeliveryPurchasePlatformService>(
        DeliveryPurchaseAppleService(
          appPurchaseRepository: AppBinding.find(),
          futureCompleterManager: AppBinding.find(),
        ),
      );
    }

    AppBinding.put<PendingPurchaseStatusService>(
      PendingPurchaseStatusService(),
    );

    AppBinding.put<CanceledPurchaseStatusService>(
      CanceledPurchaseStatusService(
        futureCompleteManager: AppBinding.find(),
      ),
    );

    AppBinding.put<ErrorPurchaseStatusService>(
      ErrorPurchaseStatusService(
        appPurchaseRepository: AppBinding.find(),
        futureCompleteManager: AppBinding.find(),
      ),
    );

    AppBinding.put<InvalidPurchaseService>(
      InvalidPurchaseService(
        // appPurchaseRepository: AppBinding.find(),
        futureCompleterManager: AppBinding.find(),
      ),
    );

    AppBinding.put<PurchasedStatusService>(
      PurchasedStatusService(
        purchaseValidationService: AppBinding.find(),
        deliveryPurchaseService: AppBinding.find(),
        invalidPurchaseService: AppBinding.find(),
      ),
    );

    AppBinding.put<PurchaseListenerUpdatesService>(
      PurchaseListenerUpdatesServiceImpl(
        inAppPurchaseService: AppBinding.find(),
        appPurchaseRepository: AppBinding.find(),
        futureCompleterManager: AppBinding.find(),
        purchasedStatusService: AppBinding.find(),
        pendingPurchaseStatusService: AppBinding.find(),
        canceledPurchaseStatusService: AppBinding.find(),
        errorPurchaseStatusService: AppBinding.find(),
      ),
    );

    AppBinding.put<AppPurchaseService>(
      AppPurchaseServiceImpl(
        appPurchaseRepository: AppBinding.find(),
        futureCompleterManager: AppBinding.find(),
        inAppPurchaseService: AppBinding.find(),
        purchaseListenerUpdatesService: AppBinding.find(),
      ),
    );

    AppBinding.put<BuyPurchaseProductUseCase>(
      BuyPurchaseProductUseCaseImpl(
        appPurchaseService: AppBinding.find(),
      ),
    );
    AppBinding.put<BuyPurchaseSubscriptionUseCase>(
      BuyPurchaseSubscriptionUseCaseImpl(
        appPurchaseService: AppBinding.find(),
      ),
    );
    AppBinding.put<UpdatePurchaseSubscriptionUseCase>(
      UpdatePurchaseSubscriptionUseCaseImpl(
        appPurchaseService: AppBinding.find(),
      ),
    );

    AppBinding.put<AppPurchaseUseCase>(
      AppPurchaseUseCaseImpl(
        appPurchaseService: AppBinding.find(),
      ),
    );
    AppBinding.put<ListAvailablePurchaseProductUseCase>(
      ListAvailablePurchaseProductUseCaseImpl(
        availablePurchaseProductService: AppBinding.find(),
      ),
    );
    AppBinding.put<ListPurchaseProductsUseCase>(
      ListPurchaseProductsUseCaseImpl(
        appPurchaseService: AppBinding.find(),
      ),
    );
    AppBinding.put<RestorePurchasesUseCase>(
      RestorePurchasesUseCaseImpl(
        appPurchaseService: AppBinding.find(),
      ),
    );

    AppBinding.put<PurchaseController>(
      PurchaseController(
        appPurchaseUseCase: AppBinding.find(),
        buyPurchaseProductUseCase: AppBinding.find(),
        buyPurchaseSubscriptionUseCase: AppBinding.find(),
        updatePurchaseSubscriptionUseCase: AppBinding.find(),
        restorePurchasesUseCase: AppBinding.find(),
        listAvailablePurchaseProductUseCase: AppBinding.find(),
        listPurchaseProductsUseCase: AppBinding.find(),
        openWebUrlUseCase: AppBinding.find(),
      ),
    );
  }
}
