import 'package:app_purchase/src/presentation/presentation.dart';
import 'package:core/core.dart';

class AppPurchaseModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.purchase.name,
      page: PurchasePage.new,
      binding: PurchaseBindings(),
    ),
  ];
}
