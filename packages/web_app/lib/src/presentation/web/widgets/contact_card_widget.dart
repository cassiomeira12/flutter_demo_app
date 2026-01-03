import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import '../web.dart';

class ContactCardWidget extends AppView<WebController> {
  const ContactCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSizeHelper.width(30),
        vertical: ResponsiveSizeHelper.height(100),
      ),
      child: Column(
        children: [
          TextWidget('contact_web'.tr, style: AppTextStyle.title(context)),
          const SpacerWidget(),
          TextWidget('follow_our_social_media'.tr),
          const SpacerWidget(),
          Wrap(
            spacing: ResponsiveSizeHelper.width(10),
            children: [
              if (controller.showInstagramButton)
                IconButtonWidget(
                  key: const Key('open_instagram_contacts_key'),
                  icon: FlutterIcon(
                    BoxIcons.bxl_instagram,
                    size: IconSize.large,
                  ),
                  onPressed: controller.openInstagram,
                ),
              if (controller.showFacebookButton)
                IconButtonWidget(
                  key: const Key('open_facebook_contacts_key'),
                  icon: FlutterIcon(
                    BoxIcons.bxl_facebook_circle,
                    size: IconSize.large,
                  ),
                  onPressed: controller.openFacebook,
                ),
              if (controller.showWhatsAppButton)
                IconButtonWidget(
                  key: const Key('open_whatsapp_contacts_key'),
                  icon: FlutterIcon(
                    BoxIcons.bxl_whatsapp,
                    size: IconSize.large,
                  ),
                  onPressed: controller.openWhatsApp,
                ),
            ],
          ),
          const SpacerWidget(),
          if (controller.showEmail)
            SelectableText(
              const String.fromEnvironment('web_contact_email'),
              style: AppTextStyle.message(context),
            ),
        ],
      ),
    );
  }
}
