import 'package:get/get.dart';

import '../../design_system/design_system.dart';
import 'settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      title: 'Ajustes',
      showBackButtonOnWeb: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              text: 'Light',
              size: ButtonSize.large,
              onPressed: () {
                controller.changeTheme('light');
              },
            ),
            Spacer(),
            PrimaryButton(
              text: 'Dark',
              size: ButtonSize.medium,
              onPressed: () {
                controller.changeTheme('dark');
              },
            ),
            Spacer(),
            PrimaryButton(
              text: 'Logout',
              size: ButtonSize.small,
              onPressed: () {
                controller.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
