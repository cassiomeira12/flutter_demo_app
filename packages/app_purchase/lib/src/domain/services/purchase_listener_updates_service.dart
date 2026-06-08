import 'package:dependency/dependency.dart';

abstract class PurchaseListenerUpdatesService {
  Future<void> onListener(List<PurchaseDetails> list);
}
