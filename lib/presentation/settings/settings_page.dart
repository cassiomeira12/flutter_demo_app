import '../../core/core.dart';
import '../../design_system/design_system.dart';
import 'settings_controller.dart';

class SettingsPage extends AppView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      title: 'settings'.tr,
      body: Column(
        children: [
          Spacer(),
          SecondaryButton(
            text: 'Idioma do App',
            onPressed: () {
              controller.changeLanguage(context);
            },
          ),
          Spacer(),
          SecondaryButton(
            text: 'Tema do App',
            onPressed: () {
              controller.changeTheme(context);
            },
          ),
          Spacer(),
          SecondaryButton(
            text: 'Ajuda',
            onPressed: controller.about,
          ),
          Spacer(),
          SecondaryButton(
            text: 'Logout',
            onPressed: () {
              controller.logout();
            },
          ),
          Spacer(),
        ],
      ),
    );
  }
}
