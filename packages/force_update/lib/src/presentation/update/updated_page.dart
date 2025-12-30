import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'update.dart';

class UpdatedPage extends AppView<UpdateController> {
  const UpdatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'updated_app_title'.tr,
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
                    Obx(() {
                      return TextWidget(
                        'updated_app_message'.tr.replaceFirst(
                          '{version}',
                          controller.newVersion.value,
                        ),
                        style: AppTextStyle.subtitle(context),
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
                        SecondaryButton(
                          text: 'updated_finish_button'.tr,
                          size: ButtonSize.medium,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
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
