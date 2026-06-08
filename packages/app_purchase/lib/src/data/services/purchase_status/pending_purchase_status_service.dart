import 'package:app_purchase/src/domain/domain.dart';
import 'package:dependency/dependency.dart';

class PendingPurchaseStatusService implements HandlerPurchaseStatusService {
  @override
  Future<void> handlePurchase(PurchaseDetails purchase) async {
    // Purchases not verified by server
    // Purchases not completed
    // Triggered on next app session
    // enviar métrica de compra pendente
  }
}
