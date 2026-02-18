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
                if (!Platform.isWeb && Platform.isIOS)
                  AppTrackingPageView(onPermission: controller.setPermission),
                // if (!Platform.isWeb && !Platform.isMacOS)
                //   PushNotificationPageView(
                //     onPermission: controller.setPermission,
                //   ),
                // LocationPageView(onPermission: controller.setPermission),
              ].map<Widget>((item) {
                controller.pagesLength += 1;
                return item;
              }).toList(),
        ),
      ),
      bottomWidget: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSizeHelper.width(20),
        ),
        height: ResponsiveSizeHelper.navigationBarHeight,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                if (controller.indexPage.value > 0) {
                  return LightButton(
                    key: const Key('back_intro_button_key'),
                    text: 'back_intro'.tr,
                    onPressed: controller.previousPage,
                  );
                }
                return const SizedBox.shrink();
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
