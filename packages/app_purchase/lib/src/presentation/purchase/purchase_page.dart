import 'package:app_purchase/src/presentation/purchase/purchase.dart';
import 'package:app_purchase/src/presentation/purchase/widgets/widgets.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class PurchasePage extends AppView<PurchaseController> {
  const PurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'purchase'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
              child: Obx(() {
                return Column(
                  spacing: ResponsiveSizeHelper.spacingDefaultHeight,
                  children: [
                    const TextWidget('Assinaturas:'),
                    ...controller.userPurchases.map((purchase) {
                      return UserPurchaseWidget(
                        purchaseDetails: purchase,
                        cancelSubscribe: controller.cancelSubscription,
                      );
                    }),
                    SecondaryButton(
                      text: 'Ver assinaturas',
                      backgroundColor: Colors.red,
                      expandWidth: true,
                      onPressed: controller.cancelSubscription,
                    ),
                    const SpacerWidget(),
                    FutureButton(
                      text: 'Restaurar compras',
                      backgroundColor: Colors.green,
                      expandWidth: true,
                      onPressed: () {
                        return controller.restore();
                      },
                    ),
                    ...controller.availablePurchases.map((purchase) {
                      return AvailablePurchaseWidget(
                        purchase: purchase,
                        disable:
                            false, // controller.userHasPurchase(purchase.id),
                        onPressed: () async {
                          try {
                            return await controller.buy(purchase.id);
                          } on BaseException catch (error) {
                            if (!context.mounted) return;
                            DialogWidget.showError(
                              context,
                              message: error.message.tr,
                            );
                          }
                        },
                      );
                    }),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
