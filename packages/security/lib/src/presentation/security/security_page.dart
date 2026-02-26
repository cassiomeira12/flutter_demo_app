import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:security/src/presentation/security/security.dart';

class SecurityPage extends AppView<SecurityController> {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'security'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(0)),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const CircularLoadingWidget();
                }
                return Column(
                  spacing: ResponsiveSizeHelper.spacingDefaultHeight * 2,
                  children: [
                    ColoredBox(
                      color: Theme.of(context).highlightColor,
                      child: Padding(
                        padding: ResponsiveSizeHelper.cardPadding,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              return IgnorePointer(
                                ignoring:
                                    !controller.hasSupportedBiometrics.value,
                                child: SwitchTitleWidget(
                                  key: const Key('biometrics_switch_key'),
                                  initialValue: controller.biometric.value,
                                  text: controller.biometric.value
                                      ? 'biometric_enabled'.tr
                                      : 'biometric_disabled'.tr,
                                  textStyle: AppTextStyle.field(context),
                                  onChanged: (enabled) {
                                    controller.toggleBiometric(enabled).then((
                                      enabled,
                                    ) {
                                      if (enabled == null) return;
                                      if (!context.mounted) return;

                                      DialogWidget.show(
                                        context,
                                        title: 'biometric'.tr,
                                        message: enabled
                                            ? 'biometrics_success_activated'.tr
                                            : 'biometrics_disabled'.tr,
                                      );
                                    });
                                  },
                                ),
                              );
                            }),
                            const SpacerWidget(),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: ResponsiveSizeHelper.maxWidth,
                              ),
                              child: TextWidget(
                                'biometric_message'.tr,
                                style: AppTextStyle.label(context),
                              ),
                            ),
                            Obx(() {
                              return Visibility(
                                visible:
                                    !controller.hasSupportedBiometrics.value,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: ResponsiveSizeHelper.height(20),
                                  ),
                                  constraints: const BoxConstraints(
                                    maxWidth: ResponsiveSizeHelper.maxWidth,
                                  ),
                                  child: TextWidget(
                                    'device_not_support_biometrics'.tr,
                                    style: AppTextStyle.message(
                                      context,
                                      color: AppColors.statusWarning,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    ColoredBox(
                      color: Theme.of(context).highlightColor,
                      child: Padding(
                        padding: ResponsiveSizeHelper.cardPadding,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              return SwitchTitleWidget(
                                key: const Key('blur_protect_switch_key'),
                                initialValue: controller.blurProtect.value,
                                text: controller.blurProtect.value
                                    ? 'blur_protect_enabled'.tr
                                    : 'blur_protect_disabled'.tr,
                                textStyle: AppTextStyle.field(context),
                                onChanged: controller.toggleBlurProtect,
                              );
                            }),
                            const SpacerWidget(),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: ResponsiveSizeHelper.maxWidth,
                              ),
                              child: TextWidget(
                                'blur_protect_message'.tr,
                                style: AppTextStyle.label(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
