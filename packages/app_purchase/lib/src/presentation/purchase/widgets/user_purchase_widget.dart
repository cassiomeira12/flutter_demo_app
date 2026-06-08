import 'package:app_purchase/src/domain/domain.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class UserPurchaseWidget extends StatelessWidget {
  final PurchaseDetailsEntity _purchaseDetails;
  final Function() cancelSubscribe;

  const UserPurchaseWidget({
    super.key,
    required this._purchaseDetails,
    required this.cancelSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveSizeHelper.cardPadding,
      color: Colors.green,
      child: Column(
        spacing: ResponsiveSizeHelper.spacingDefaultHeight,
        children: [
          TextWidget(_purchaseDetails.purchaseID ?? 'Sem purchaseID'),
          TextWidget(_purchaseDetails.productId),
          TextWidget(_purchaseDetails.prouctPrice),
          TextWidget(_purchaseDetails.source),
          TextWidget('Cancelada: ${_purchaseDetails.cancelled}'),
          if (!_purchaseDetails.cancelled)
            PrimaryButton(
              text: 'Cancelar assinatura',
              onPressed: cancelSubscribe,
            ),
        ],
      ),
    );
  }
}
