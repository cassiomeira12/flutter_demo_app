import 'package:app_purchase/src/domain/domain.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class AppPurchaseUseCase extends UseCase {
  Stream<List<PurchaseDetailsEntity>> get userPurchases;

  Future<void> init({required String userIdentifierId});

  void close();

  Future<bool> isServiceAvailable();
}

class AppPurchaseUseCaseImpl implements AppPurchaseUseCase {
  final AppPurchaseService _service;

  AppPurchaseUseCaseImpl({
    required AppPurchaseService appPurchaseService,
  }) : _service = appPurchaseService;

  @override
  Stream<List<PurchaseDetailsEntity>> get userPurchases =>
      _service.userPurchases;

  @override
  Future<void> init({required String userIdentifierId}) {
    return _service.init(userIdentifierId: userIdentifierId);
  }

  @override
  void close() {
    return _service.close();
  }

  @override
  Future<bool> isServiceAvailable() {
    return _service.isServiceAvailable();
  }
}
