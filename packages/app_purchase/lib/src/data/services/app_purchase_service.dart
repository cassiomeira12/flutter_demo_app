import 'package:app_purchase/src/data/services/future_completer_manager.dart';
import 'package:app_purchase/src/data/services/mixins/mixins.dart';
import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppPurchaseServiceImpl
    with
        HandlerPurchaseErrorMixin,
        UpdateAndroidPurchaseSubscriptionMixin,
        LogPurchaseMixin
    implements AppPurchaseService {
  final InAppPurchaseService _inAppPurchaseService;
  final AppPurchaseRepository _appPurchaseRepository;
  final FutureCompleterManager _futureCompleterManager;
  final PurchaseListenerUpdatesService _purchaseListenerUpdatesService;

  AppPurchaseServiceImpl({
    required this._inAppPurchaseService,
    required this._appPurchaseRepository,
    required this._futureCompleterManager,
    required this._purchaseListenerUpdatesService,
  });

  String? _userIdentifierId;
  StreamSubscription<List<PurchaseDetails>>? _purchaseStreamSubscription;
  final Map<String, AvailablePurchaseEntity> _productsAvailable = {};

  @override
  Stream<List<PurchaseDetailsEntity>> get userPurchases =>
      _appPurchaseRepository.userPurchases;

  @override
  Future<void> init({required String userIdentifierId}) async {
    final isAvailable = await isServiceAvailable();
    if (!isAvailable) {
      throw BaseException(message: '$runtimeType not available');
    }
    _userIdentifierId = userIdentifierId;
    Log.success('$runtimeType Stream Subscription START');
    _purchaseStreamSubscription = _inAppPurchaseService.purchaseStream.listen(
      _purchaseListenerUpdatesService.onListener,
      onDone: () {
        Log.debug('$runtimeType Stream Subscription DONE');
        _purchaseStreamSubscription?.cancel();
      },
      onError: (Object error) {
        Log.debug('$runtimeType Stream Subscription ERROR');
        Log.error(error, null);
        _purchaseStreamSubscription?.cancel();
      },
    );
    Log.success('$runtimeType init success for user: $_userIdentifierId');
    // restorePurchases();
  }

  @override
  void close() {
    Log.debug('$runtimeType close');
    _purchaseStreamSubscription?.cancel();
    _productsAvailable.clear();
    // purchaseStore.clear();
    _userIdentifierId = null;
  }

  @override
  Future<bool> isServiceAvailable() async {
    try {
      final bool isAvailable = await _inAppPurchaseService.isAvailable();
      Log.success('$runtimeType isAvailable: $isAvailable');
      return isAvailable;
    } on BaseException catch (error) {
      Log.baseException(error);
      return false;
    }
  }

  @override
  Future<void> buyProduct(
    PurchaseProductEntity product,
  ) async {
    await checkIfReady(_userIdentifierId);
    final ProductDetails? productDetails =
        _appPurchaseRepository.productsDetailsMap[product.id];
    if (productDetails == null) throw NotFoundException();

    final completer = _futureCompleterManager.startFutureFunction(
      purchaseProductId: product.id,
    );

    logPurchaseProductEntity(
      product,
      _userIdentifierId,
    );

    try {
      final purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: _userIdentifierId,
      );
      _appPurchaseRepository.setPurchaseInProgress(productId: product.id);
      await _inAppPurchaseService.buyConsumable(purchaseParam);
    } on BaseException catch (error) {
      Log.baseException(error);
      _futureCompleterManager.completerError(error);
    }

    return completer.future;
  }

  @override
  Future<void> buySubscription(
    PurchaseSubscriptionEntity subscription,
  ) async {
    await checkIfReady(_userIdentifierId);
    final ProductDetails? productDetails =
        _appPurchaseRepository.productsDetailsMap[subscription.id];
    if (productDetails == null) throw NotFoundException();

    final completer = _futureCompleterManager.startFutureFunction(
      purchaseProductId: subscription.id,
    );

    logPurchaseProductEntity(
      subscription,
      _userIdentifierId,
    );

    try {
      final purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: _userIdentifierId,
      );
      _appPurchaseRepository.setPurchaseInProgress(productId: subscription.id);
      await _inAppPurchaseService.buyNonConsumable(purchaseParam);
    } on BaseException catch (error) {
      Log.baseException(error);
      _futureCompleterManager.completerError(error);
    }

    return completer.future;
  }

  @override
  Future<void> updateSubscription({
    required PurchaseDetailsEntity oldSubscription,
    required PurchaseSubscriptionEntity newSubscription,
  }) async {
    if (!Platform.isAndroid) throw UnimplementedError();

    await checkIfReady(_userIdentifierId);

    Log.debug(
      '$runtimeType.updateSubscription for user: $_userIdentifierId \n'
      'oldSubscription: ${oldSubscription.productId} \n'
      'newSubscription: ${newSubscription.id} ${newSubscription.price} \n',
    );

    final oldSubscriptionDetails = _appPurchaseRepository.getPurchaseDetails(
      oldSubscription.purchaseID!,
    );
    final newSubscriptionDetails =
        _appPurchaseRepository.productsDetailsMap[newSubscription.id];

    if (oldSubscriptionDetails == null || newSubscriptionDetails == null) {
      throw NotFoundException();
    }

    final completer = _futureCompleterManager.startFutureFunction(
      purchaseProductId: newSubscription.id,
    );

    logPurchaseProductEntity(
      newSubscription,
      _userIdentifierId,
    );

    try {
      final PurchaseParam purchaseParam = await parseUpdateAndroidSubscription(
        oldSubscription: oldSubscriptionDetails,
        newSubscription: newSubscriptionDetails,
        applicationUserName: _userIdentifierId,
      );
      _appPurchaseRepository.setPurchaseInProgress(
        productId: newSubscriptionDetails.id,
      );
      await _inAppPurchaseService.buyNonConsumable(purchaseParam);
    } on BaseException catch (error) {
      Log.baseException(error);
      _futureCompleterManager.completerError(error);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }

    return completer.future;
  }

  @override
  Future<void> restorePurchases() async {
    await checkIfReady(_userIdentifierId);

    final completer = _futureCompleterManager.startFutureFunction();

    try {
      Log.debug('$runtimeType.restorePurchases for user: $_userIdentifierId');
      await _inAppPurchaseService.restorePurchases(
        _userIdentifierId!,
      );
    } on BaseException catch (error) {
      Log.baseException(error);
      _futureCompleterManager.completerError(error);
    }

    return completer.future;
  }

  @override
  Future<List<PurchaseEntity>> queryProductDetails(
    List<AvailablePurchaseEntity> products,
  ) async {
    await checkIfReady(_userIdentifierId);
    try {
      Log.debug(
        '$runtimeType.queryProductDetails \n'
        '${products.toString().replaceAll('AvailableProductEntity', '')}',
      );

      final ids = products.map((product) => product.id).toList();
      final result = await _inAppPurchaseService.queryProducts(ids);

      for (final product in products) {
        _productsAvailable[product.id] = product;
      }

      if (result.notFoundIDs.isNotEmpty) {
        Log.warning('Products Not Found: ${result.notFoundIDs}');
        for (final id in result.notFoundIDs) {
          _productsAvailable.remove(id);
        }
      }

      return result.productDetails.map((product) {
        _appPurchaseRepository.productsDetailsMap[product.id] = product;
        final productAvailable = _productsAvailable[product.id]!;

        final PurchaseEntity purchaseEntity = productAvailable.consumableProduct
            ? PurchaseProductEntity(
                id: productAvailable.id,
                productTitle: productAvailable.title,
                purchaseTitle: product.title,
                purhcaseDescription: product.description,
                price: product.price,
                rawPrice: product.rawPrice,
                currencyCode: product.currencyCode,
                currencySymbol: product.currencySymbol,
              )
            : PurchaseSubscriptionEntity(
                id: productAvailable.id,
                productTitle: productAvailable.title,
                purchaseTitle: product.title,
                purhcaseDescription: product.description,
                price: product.price,
                rawPrice: product.rawPrice,
                currencyCode: product.currencyCode,
                currencySymbol: product.currencySymbol,
              );

        logPurchaseEntity(purchaseEntity);

        return purchaseEntity;
      }).toList();
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    }
  }

  Future<void> checkIfReady(String? userIdentifierId) async {
    final isAvailable = await isServiceAvailable();
    if (!isAvailable) {
      throw BaseException(message: '$runtimeType not available');
    }
    if (userIdentifierId == null) {
      throw BaseException(message: '$runtimeType not initialized');
    }
  }
}
