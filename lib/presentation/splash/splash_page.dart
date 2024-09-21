import '../../core/core.dart';
import '../../design_system/design_system.dart';
import 'splash_controller.dart';

class SplashPage extends AppView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      //backgroundColor: AppColors.warning,
      // controller: controller,
      body: Center(
        child: AppIcon(
          AppIcons.logo,
          size: IconSize.large,
        ),
      ),
      bottomWidget: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
