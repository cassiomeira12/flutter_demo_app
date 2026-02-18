import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:web_app/src/presentation/web/web.dart';

class FooterWidget extends AppView<WebController> {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSizeHelper.width(20),
        vertical: ResponsiveSizeHelper.width(20),
      ),
      color: Theme.of(context).primaryColor,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: ResponsiveSizeHelper.height(10),
        children: [
          TextRichWidget(
            children: [
              TextRichWidget(
                text: '© Copyright ',
                style: AppTextStyle.message(context, color: AppColors.white),
              ),
              TextRichWidget(
                text: '${controller.environment.appName}. ',
                style: AppTextStyle.message(
                  context,
                  bold: true,
                  color: AppColors.white,
                ),
              ),
              TextRichWidget(
                text: 'copyright_web_app'.tr,
                style: AppTextStyle.message(context, color: AppColors.white),
              ),
            ],
          ),
          LightButton(
            key: const Key('privacy_policy_footer_key'),
            text: 'privacy_policy'.tr,
            textStyle: AppTextStyle.button(context, color: AppColors.white),
            onPressed: controller.privacyPolicy,
          ),
          LightButton(
            key: const Key('terms_conditions_footer_key'),
            text: 'terms_conditions'.tr,
            textStyle: AppTextStyle.button(context, color: AppColors.white),
            onPressed: controller.termsConditions,
          ),
          LightButton(
            key: const Key('help_and_support_footer_key'),
            text: 'sac_help'.tr,
            textStyle: AppTextStyle.button(context, color: AppColors.white),
            onPressed: controller.helpAndSupport,
          ),
        ],
      ),
    );
  }
}
