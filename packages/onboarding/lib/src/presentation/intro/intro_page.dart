import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:onboarding/src/presentation/intro/intro.dart';
import 'package:onboarding/src/presentation/intro/page_view/page_view.dart';

class IntroPage extends AppView<IntroController> {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      body: IgnorePointer(
        child: PageView(
          controller: controller.pageController,
          onPageChanged: (index) {
            controller.indexPage(index);
          },
          children:
              [
                AppPageView(appName: controller.appName),
                ...controller.permissions.map<Widget>((permission) {
                  switch (permission) {
                    case 'appTrackingTransparency':
                      return AppTrackingPageView(
                        onPermission: controller.setPermission,
                      );
                    case 'notification':
                      return PushNotificationPageView(
                        onPermission: controller.setPermission,
                      );
                    case 'location':
                      return LocationPageView(
                        onPermission: controller.setPermission,
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ].map<Widget>((item) {
                controller.pagesLength += 1;
                return item;
              }).toList(),
        ),
      ),
      bottomWidget: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveSizeHelper.width(10),
          horizontal: ResponsiveSizeHelper.width(20),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return Visibility(
                  visible: controller.indexPage.value > 0,
                  child: LightButton(
                    key: const Key('back_intro_button_key'),
                    text: 'back_intro'.tr,
                    size: ButtonSize.medium,
                    onPressed: controller.previousPage,
                  ),
                );
              }),
              Obx(() {
                if (controller.isLastPage.value) {
                  return PrimaryButton(
                    key: const Key('finish_intro_button_key'),
                    text: 'finish_intro'.tr,
                    size: ButtonSize.medium,
                    onPressed: controller.nextPage,
                  );
                }
                return PrimaryButton(
                  key: const Key('next_intro_button_key'),
                  text: 'next_intro'.tr,
                  size: ButtonSize.medium,
                  onPressed: controller.nextPage,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
