import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

mixin HandlerPurchaseErrorMixin {
  BaseException purchaseError(PurchaseDetails purchase) {
    if (purchase.error?.message != null) {
      switch (purchase.error?.message) {
        /// Success.
        case 'BillingResponse.ok':

        /// Fatal error during the API action.
        case 'BillingResponse.error':

        /// Invalid arguments provided to the API.
        /// Quando não faz o complete purchase
        case 'BillingResponse.developerError':

        /// The requested feature is not supported by Play Store on the current device.
        case 'BillingResponse.featureNotSupported':

        /// The Play Store service is not connected now - potentially transient state.
        case 'BillingResponse.serviceDisconnected':

        /// Failure to consume since item is not owned.
        case 'BillingResponse.itemNotOwned':
          return BaseException(
            message: purchase.error?.message,
            error: purchase.error.toString(),
            // stackTrace: StackTrace.current,
          );

        /// The request has reached the maximum timeout before Google Play responds.
        case 'BillingResponse.serviceTimeout':
          return ServiceTimeoutException();

        /// The user pressed back or canceled a dialog.
        case 'BillingResponse.userCanceled':
          return UserCanceledException();

        /// The network connection is down.
        case 'BillingResponse.serviceUnavailable':
          return ServiceUnavailableException();

        /// The billing API version is not supported for the type requested.
        case 'BillingResponse.billingUnavailable':
          return BillingUnavailableException(); // Pagamento recursado

        /// The requested product is not available for purchase.
        case 'BillingResponse.itemUnavailable':
          return ItemUnavailableException();

        /// Failure to purchase since item is already owned.
        case 'BillingResponse.itemAlreadyOwned':
          return ItemAlreadyOwnedException();

        /// Network connection failure between the device and Play systems.
        case 'BillingResponse.networkError':
          return NetworkErrorException();
      }
    }

    return BaseException(
      message: purchase.error?.message,
      error: purchase.error.toString(),
      stackTrace: StackTrace.current,
    );
  }
}
