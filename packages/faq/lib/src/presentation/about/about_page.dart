import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'about.dart';

class AboutPage extends AppView<AboutController> {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'about'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
              child: Column(
                spacing: ResponsiveSizeHelper.spacingDefaultHeight,
                children: [
                  SecondaryButton(
                    key: const Key('about_app_review_key'),
                    text: 'Avalie o aplicativo'.tr,
                    expandWidth: true,
                    icon: FlutterIcon(Icons.feedback_outlined),
                    onPressed: () async {
                      try {
                        await controller.appReview();
                      } on BaseException catch (error) {
                        if (!context.mounted) return;
                        DialogWidget.show(
                          context,
                          title: 'default_error'.tr,
                          message: error.toString().tr,
                        );
                      } catch (error) {
                        if (!context.mounted) return;
                        DialogWidget.show(
                          context,
                          title: 'default_error'.tr,
                          message: error.toString().tr,
                        );
                      }
                    },
                  ),
                  SecondaryButton(
                    key: const Key('about_app_whats_new_key'),
                    text: 'O que há de novo'.tr,
                    expandWidth: true,
                    icon: FlutterIcon(Icons.system_update),
                    onPressed: controller.appWhatsNew,
                  ),
                  SecondaryButton(
                    key: const Key('about_terms_conditions_key'),
                    text: 'terms_conditions'.tr,
                    expandWidth: true,
                    icon: FlutterIcon(Icons.shield),
                    onPressed: controller.termsConditions,
                  ),
                  SecondaryButton(
                    key: const Key('about_privacy_policy_key'),
                    text: 'privacy_policy'.tr,
                    expandWidth: true,
                    icon: FlutterIcon(Icons.shield),
                    onPressed: controller.privacyPolicy,
                  ),
                  if (controller.showOpenWebSiteButton && !Platform.isWeb)
                    SecondaryButton(
                      key: const Key('about_open_website_key'),
                      text: 'open_website'.tr,
                      expandWidth: true,
                      icon: FlutterIcon(Icons.web_sharp),
                      onPressed: controller.openWebSite,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
