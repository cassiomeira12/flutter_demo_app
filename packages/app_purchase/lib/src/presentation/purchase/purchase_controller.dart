import 'package:app_purchase/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class PurchaseController extends BaseController {
  final AppPurchaseUseCase _appPurchaseUseCase;
  final BuyPurchaseProductUseCase _buyPurchaseProductUseCase;
  final BuyPurchaseSubscriptionUseCase _buyPurchaseSubscriptionUseCase;
  final UpdatePurchaseSubscriptionUseCase _updatePurchaseSubscriptionUseCase;
  final RestorePurchasesUseCase _restorePurchasesUseCase;
  final ListAvailablePurchaseProductUseCase
  _listAvailablePurchaseProductUseCase;
  final ListPurchaseProductsUseCase _listPurchaseProductsUseCase;
  final OpenWebUrlUseCase _openWebUrlUseCase;

  PurchaseController({
    required this._appPurchaseUseCase,
    required this._buyPurchaseProductUseCase,
    required this._buyPurchaseSubscriptionUseCase,
    required this._updatePurchaseSubscriptionUseCase,
    required this._restorePurchasesUseCase,
    required this._listAvailablePurchaseProductUseCase,
    required this._listPurchaseProductsUseCase,
    required this._openWebUrlUseCase,
  });

  final List<AvailablePurchaseEntity> _availableProducts = List.empty(
    growable: true,
  );

  final RxList<PurchaseEntity> availablePurchases = RxList.empty(
    growable: true,
  );

  late StreamSubscription<List<PurchaseDetailsEntity>>
  _userPurchasesSubscription;

  final RxMap<String, PurchaseDetailsEntity> _userPurchases = RxMap.from({});

  List<PurchaseDetailsEntity> get userPurchases =>
      _userPurchases.values.toList();

  bool userHasPurchase(String productId) {
    return _userPurchases.values.where((purchase) {
      return purchase.productId == productId && !purchase.cancelled;
    }).isNotEmpty;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _appPurchaseUseCase.init(
      userIdentifierId: '89691f19-7d13-4aa3-898f-0a4e345a6743',
    );
    _userPurchasesSubscription = _appPurchaseUseCase.userPurchases.listen(
      _userPurchasesListener,
    );
    _listAvailableProducts();
  }

  @override
  void dispose() {
    _userPurchasesSubscription.cancel();
    _appPurchaseUseCase.close();
    super.dispose();
  }

  void _userPurchasesListener(List<PurchaseDetailsEntity> list) {
    for (final purchase in list) {
      _userPurchases[purchase.purchaseID!] = purchase;
    }
  }

  Future<void> _listAvailableProducts() async {
    await _listAvailablePurchaseProductUseCase.call().then(
      _availableProducts.addAll,
    );
    await _listPurchaseProductsUseCase
        .call(_availableProducts)
        .then(availablePurchases.addAll);
    restore();
  }

  Future<void> buy(String productId) async {
    try {
      final purchaseEntity = availablePurchases
          .where((product) => product.id == productId)
          .first;

      if (purchaseEntity is PurchaseProductEntity) {
        await _buyPurchaseProductUseCase.call(purchaseEntity);
      }

      if (purchaseEntity is PurchaseSubscriptionEntity) {
        final userActiveSubscriptions = _userPurchases.values.where((purchase) {
          return !purchase.cancelled && purchase.productId != productId;
        });
        if (userActiveSubscriptions.isEmpty) {
          await _buyPurchaseSubscriptionUseCase.call(purchaseEntity);
        } else {
          final oldSubscription = userActiveSubscriptions.first;
          await _updatePurchaseSubscriptionUseCase.call(
            oldSubscription: oldSubscription,
            newSubscription: purchaseEntity,
          );
        }
      }
    } on UserCanceledException {
      Log.info('cancelado pelo usuário');
    } on ItemAlreadyOwnedException catch (error) {
      throw BaseException(
        message: error.message.tr.replaceAll(
          '{purchase}',
          'Teste',
        ),
      );
    } on BaseException {
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  Future<void> restore() async {
    try {
      await _restorePurchasesUseCase.call();
    } on BaseException catch (error) {
      Log.warning(error.toString());
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
    }
  }

  Future<void> cancelSubscription() async {
    const String androidUrl =
        'https://play.google.com/store/account/subscriptions';
    const String appleUrl =
        'https://finance-app.itunes.apple.com/connecting-client?targetUrl=https%3A%2F%2Ffinance-app.itunes.apple.com%2Faccount%2Fsubscriptions';

    try {
      if (Platform.appleDevice) {
        await _openWebUrlUseCase.call(appleUrl);
      }
      if (Platform.isAndroid) {
        await _openWebUrlUseCase.call(androidUrl);
      }
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }
}
