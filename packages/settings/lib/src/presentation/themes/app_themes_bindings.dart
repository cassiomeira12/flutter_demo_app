import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:settings/src/data/data.dart';
import 'package:settings/src/domain/domain.dart';
import 'package:settings/src/presentation/themes/app_themes.dart';

class AppThemesBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<DynamicIconService>(
      DynamicIconServiceImpl(
        defaultIcon: const String.fromEnvironment('app_icon_apple'),
        iconsAvailable: const String.fromEnvironment('app_icons_available'),
      ),
    );

    AppBinding.put<DynamicIconUseCase>(
      DynamicIconUseCaseImpl(
        dynamicIconService: AppBinding.find(),
      ),
    );

    AppBinding.put<AppThemesController>(
      AppThemesController(
        themeController: AppBinding.find(),
        dynamicIconUseCase: AppBinding.find(),
      ),
    );
  }
}
