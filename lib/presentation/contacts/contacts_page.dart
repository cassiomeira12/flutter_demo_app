import 'package:get/get.dart';

import '../../design_system/design_system.dart';
import '../app_router.dart';
import 'contacts_controller.dart';

class ContactsPage extends GetView<ContactsController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      title: 'Contatos',
      showBackButtonOnWeb: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              text: 'Open Emergency ${DateTime.now().second}',
              size: ButtonSize.small,
              onPressed: () {
                AppRouter.toNamed(
                  AppRouter.emergency,
                  id: 0,
                );
              },
            ),
            TextWidget(
              'title',
              style: AppTextStyle.title(context),
            ),
            TextWidget(
              'subtitle',
              style: AppTextStyle.subtitle(context),
            ),
            TextWidget(
              'message',
              style: AppTextStyle.message(context),
            ),
            TextWidget(
              'label',
              style: AppTextStyle.label(context),
            ),
            TextWidget(
              'button',
              style: AppTextStyle.button(context),
            ),
            TextWidget(
              'hyperlink',
              style: AppTextStyle.hyperlink(context),
            ),
            TextWidget(
              'footnote',
              style: AppTextStyle.footnote(context),
            ),
          ],
        ),
      ),
    );
  }
}
