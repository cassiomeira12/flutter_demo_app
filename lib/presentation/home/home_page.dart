import 'package:get/get.dart';

import '../../design_system/design_system.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigatorRouterWidget(
      pages: [],
      selectedIndex: controller.selectedIndex,
      changeTab: controller.changeTab,
      bottomItems: _bottomItemsList,
    );
  }

  List<BottomItem> get _bottomItemsList => [
        BottomItem(
          title: 'Home',
          selectedIcon: FlutterIcon(
            Icons.home,
            size: IconSize.medium,
          ),
          unselectedIcon: FlutterIcon(
            Icons.home,
            size: IconSize.medium,
          ),
        ),
      ];
}
