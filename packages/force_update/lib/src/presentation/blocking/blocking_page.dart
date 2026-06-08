import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:force_update/src/presentation/blocking/blocking.dart';

class BlockingPage extends AppView<BlockingController> {
  const BlockingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      canPop: false,
      hideAppBar: true,
      title: '',
      controller: controller,
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SpacerWidget(),
              Image.asset(
                AppIcons.maintenance.value,
                width: ResponsiveSizeHelper.width(100),
                height: ResponsiveSizeHelper.width(100),
              ),
              const SpacerWidget(),
              TextWidget(
                'blocking_app_title'.tr,
                style: AppTextStyle.subtitle(context),
              ),
              const SpacerWidget(height: 3),
              TextWidget(
                'blocking_app_message'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyle.subtitle(context),
              ),
              const SpacerWidget(height: 2),
              ValueListenableBuilder(
                valueListenable: controller.pushSubscribed,
                builder: (context, value, child) {
                  return Visibility(visible: value, child: child!);
                },
                child: TextWidget(
                  'blocking_push_notification'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.subtitle(context),
                ),
              ),
              const SpacerWidget(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}
