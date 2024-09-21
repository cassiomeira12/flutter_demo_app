import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/app_router.dart';

import '../../core/core.dart';
import '../../design_system/design_system.dart';
import '../../translations/translation.dart';

class SettingsController extends BaseController {
  final ThemeController _themeController;
  final ILocalStorageUseCase _localStorage;

  SettingsController({
    required ThemeController themeController,
    required ILocalStorageUseCase localStorage,
  })  : _themeController = themeController,
        _localStorage = localStorage;

  void changeTheme(BuildContext context) {
    BottomSheetWidget.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ThemeController.themes.keys.map((theme) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PrimaryButton(
              text: theme.capitalizeFirst,
              onPressed: () {
                _themeController.changeTheme(theme);
                Get.back();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void changeLanguage(BuildContext context) {
    BottomSheetWidget.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: Translation.supportedLocales.map((locale) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PrimaryButton(
              text: locale.toLanguageTag(),
              onPressed: () {
                Get.updateLocale(locale);
                Get.back();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void logout() {
    _localStorage.clearAll();
    AppRouter.backAllAndToNamed(AppRouter.login);
  }

  void about() {
    AppRouter.toNamed(AppRouter.about, id: 2);
  }
}
