import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'update.dart';

class UpdatePage extends AppView<UpdateController> {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'update_app'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: ResponsiveSizeHelper.maxWidth,
                ),
                padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpacerWidget(),
                    TextWidget(
                      'new_version_app'.tr,
                      style: AppTextStyle.subtitle(context),
                    ),
                    const SpacerWidget(),
                    Obx(() {
                      return TextWidget(
                        '${controller.currentVersion.value} -> ${controller.newVersion.value}',
                      );
                    }),
                    Obx(() {
                      return Visibility(
                        visible: controller.news.value.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SpacerWidget(height: 2),
                            TextWidget(
                              'update_news_title'.tr,
                              style: AppTextStyle.subtitle(context),
                            ),
                            const SpacerWidget(),
                            TextWidget(controller.news.value),
                          ],
                        ),
                      );
                    }),
                    Obx(() {
                      return Visibility(
                        visible: controller.improvements.value.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SpacerWidget(height: 2),
                            TextWidget(
                              'update_improvements_title'.tr,
                              style: AppTextStyle.subtitle(context),
                            ),
                            const SpacerWidget(),
                            TextWidget(controller.improvements.value),
                          ],
                        ),
                      );
                    }),
                    Obx(() {
                      return Visibility(
                        visible: controller.fixes.value.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SpacerWidget(height: 2),
                            TextWidget(
                              'update_fixes_title'.tr,
                              style: AppTextStyle.subtitle(context),
                            ),
                            const SpacerWidget(),
                            TextWidget(controller.fixes.value),
                          ],
                        ),
                      );
                    }),
                    const SpacerWidget(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryButton(
                          key: const Key('update_now_button_key'),
                          text: 'update_now_button'.tr,
                          size: ButtonSize.medium,
                          onPressed: controller.updateNow,
                        ),
                      ],
                    ),
                    const SpacerWidget(height: 2),
                    Obx(() {
                      return Visibility(
                        visible: !controller.requiredUpdate.value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LightButton(
                              key: const Key('update_later_button_key'),
                              text: 'update_later_button'.tr,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
