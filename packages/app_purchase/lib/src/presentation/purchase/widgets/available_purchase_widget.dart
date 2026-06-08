import 'package:app_purchase/src/domain/domain.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class AvailablePurchaseWidget extends StatelessWidget {
  final PurchaseEntity _purchase;
  final bool _disable;
  final Future<void> Function() _onPressed;

  const AvailablePurchaseWidget({
    super.key,
    required this._purchase,
    required this._disable,
    required this._onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FutureButton(
      text: _purchase.title,
      expandWidth: true,
      backgroundColor: _disable ? Colors.blueGrey : Colors.blueAccent,
      onPressed: _disable ? null : _onPressed,
    );
  }
}
