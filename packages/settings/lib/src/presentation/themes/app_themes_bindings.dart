import 'package:core/core.dart' hide ThemeController;
import 'package:dependency/dependency.dart';
import 'package:settings/src/presentation/themes/app_themes.dart';

class AppThemesBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<AppThemesController>(
      AppThemesController(
        themeController: AppBinding.find(),
        dynamicIconUseCase: AppBinding.find(),
      ),
    );
  }
}
