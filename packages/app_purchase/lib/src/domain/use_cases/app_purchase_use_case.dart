import 'package:app_purchase/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class AppPurchaseUseCase extends UseCase {
  Stream<List<PurchaseDetailsEntity>> get userPurchases;

  Future<void> init({required String userIdentifierId});

  void close();

  Future<bool> isServiceAvailable();
}

class AppPurchaseUseCaseImpl implements AppPurchaseUseCase {
  final AppPurchaseService _appPurchaseService;

  AppPurchaseUseCaseImpl({required this._appPurchaseService});

  @override
  Stream<List<PurchaseDetailsEntity>> get userPurchases =>
      _appPurchaseService.userPurchases;

  @override
  Future<void> init({required String userIdentifierId}) {
    return _appPurchaseService.init(userIdentifierId: userIdentifierId);
  }

  @override
  void close() {
    return _appPurchaseService.close();
  }

  @override
  Future<bool> isServiceAvailable() {
    return _appPurchaseService.isServiceAvailable();
  }
}
