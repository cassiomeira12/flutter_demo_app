import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'security.dart';

class SecurityBlockedPage extends AppView<SecurityController> {
  const SecurityBlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      canPop: false,
      controller: controller,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterIcon(BoxIcons.bxs_lock, size: IconSize.medium),
            const SpacerWidget(),
            TextWidget(
              'blocked_app'.tr,
              style: AppTextStyle.subtitle(context, fontSize: TextSize.font_20),
            ),
            const SpacerWidget(),
            TextWidget(
              'use_biometrics_to_unlock_app'.tr,
              style: AppTextStyle.message(context, fontSize: TextSize.font_14),
            ),
            const SpacerWidget(height: 3),
            PrimaryButton(
              text: 'unlock_app'.tr,
              onPressed: controller.unlockApp,
            ),
          ],
        ),
      ),
      bottomWidget: SizedBox(
        height: ResponsiveSizeHelper.navigationBarHeight,
        child: Center(
          child: LightButton(
            key: const Key('security_blocked_app_logout_key'),
            text: 'logout'.tr,
            onPressed: () async {
              final bool? result = await DialogWidget.showChoice(
                context,
                title: 'logout'.tr,
                message: 'logout_app_message'.tr,
                okButton: 'logout'.tr,
              );
              if (result == true) {
                await controller.logout();
              }
            },
          ),
        ),
      ),
    );
  }
}
