import 'package:dependency/dependency.dart';

abstract class HandlerPurchaseStatusService {
  Future<void> handlePurchase(PurchaseDetails purchase);
}
