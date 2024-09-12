import 'package:get/get.dart';

import '../../design_system/design_system.dart';
import '../app_router.dart';
import 'emergency_controller.dart';

class EmergencyPage extends GetResponsiveView<EmergencyController> {
  @override
  Widget build(BuildContext context) {
    //ResponsiveScreenSettings
    //print(ResponsiveSizeHelper.mediaQuery.size.width);
    //print(ResponsiveSizeHelper.mediaQuery.size.height);
    return ScaffoldWidget(
      controller: controller,
      title: 'Emergencia',
      showBackButtonOnWeb: true,
      body: Center(
        child: PrimaryButton(
          text: 'Open contacts ${DateTime.now().second}',
          size: ButtonSize.small,
          onPressed: () {
            AppRouter.toNamed(
              AppRouter.contacts,
              id: 0,
            );
          },
        ),
      ),
    );
  }
}
