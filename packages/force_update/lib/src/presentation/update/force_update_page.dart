import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:force_update/src/presentation/update/update.dart';

class ForceUpdatePage extends AppView<UpdateController> {
  const ForceUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'update_app'.tr,
      controller: controller,
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: ResponsiveSizeHelper.maxWidth,
            ),
            padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SpacerWidget(),
                Image.asset(
                  AppIcons.updateAvailable.value,
                  width: ResponsiveSizeHelper.width(100),
                  height: ResponsiveSizeHelper.width(100),
                ),
                const SpacerWidget(height: 2),
                TextWidget(
                  'new_version_app'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.subtitle(context),
                ),
                const SpacerWidget(),
                TextWidget(
                  'new_version_app_message'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.message(context),
                ),
                const SpacerWidget(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton(
                      key: const Key('update_now_button_key'),
                      text: 'update_now_button'.tr,
                      onPressed: controller.updateNow,
                    ),
                  ],
                ),
                const SpacerWidget(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
