import 'package:get/get.dart';

import '../../design_system/design_system.dart';
import '../contacts/contacts.dart';
import '../emergency/emergency.dart';
import '../settings/settings.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigatorRouterWidget(
      pages: [
        ...EmergencyModule.routes,
        ...ContactsModule.routes,
        ...SettingsModule.routes,
      ],
      selectedIndex: controller.selectedIndex,
      changeTab: controller.changeTab,
      bottomItems: _bottomItemsList,
    );
  }

  List<BottomItem> get _bottomItemsList => [
        BottomItem(
          title: 'Emergencia',
          selectedIcon: FlutterIcon(
            Icons.home,
            size: IconSize.medium,
          ),
          unselectedIcon: FlutterIcon(
            Icons.home,
            size: IconSize.medium,
          ),
        ),
        BottomItem(
          title: 'Contatos',
          selectedIcon: FlutterIcon(
            Icons.contact_emergency,
            size: IconSize.medium,
          ),
          unselectedIcon: FlutterIcon(
            Icons.contact_emergency,
            size: IconSize.medium,
          ),
        ),
        BottomItem(
          title: 'Ajustes',
          selectedIcon: FlutterIcon(
            Icons.settings,
            size: IconSize.medium,
          ),
          unselectedIcon: FlutterIcon(
            Icons.settings,
            size: IconSize.medium,
          ),
        ),
      ];
}
