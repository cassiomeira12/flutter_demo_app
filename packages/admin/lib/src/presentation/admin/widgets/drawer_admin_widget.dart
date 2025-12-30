import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import '../admin.dart';

class DrawerAdminWidget extends AppView<AdminController> {
  const DrawerAdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerWebWidget(
      key: const Key('drawer_admin_key'),
      children: [
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: ResponsiveSizeHelper.width(50),
                height: ResponsiveSizeHelper.width(50),
                child: ImageWidget(imageUrl: controller.user.avatarUrl),
              ),
              const SpacerWidget(),
              TextRichWidget(
                children: [
                  TextRichWidget(
                    text: 'Olá, ',
                    style: AppTextStyle.button(context),
                  ),
                  TextRichWidget(
                    text: controller.user.firstName,
                    style: AppTextStyle.button(context, bold: true),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ScrollViewWidget(
            child: (scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    ...[
                      'users',
                      'notifications',
                      'web_visit_history',
                      'settings',
                    ].asMap().entries.map((entry) {
                      return Obx(() {
                        return FlatButton(
                          key: Key('${entry.value}_drawer_item_key'),
                          text: entry.value.tr,
                          expandWidth: true,
                          color: controller.selectedIndex.value == entry.key
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Theme.of(context).drawerTheme.backgroundColor,
                          onPressed: () {
                            _closeDrawer(context);
                            controller.changeTab(
                              entry.key,
                              '${entry.value}_drawer_item_key',
                            );
                          },
                        );
                      });
                    }),
                    FlatButton(
                      key: const Key('logout_drawer_item_key'),
                      text: 'logout'.tr,
                      expandWidth: true,
                      color: Theme.of(context).drawerTheme.backgroundColor,
                      onPressed: () async {
                        final bool? result = await DialogWidget.showChoice(
                          context,
                          title: 'logout'.tr,
                          message: 'logout_app_message'.tr,
                          okButton: 'logout'.tr,
                        );
                        if (result == true) {
                          await controller.logout();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.center,
              height: ResponsiveSizeHelper.navigationBarHeight,
              child: TextWidget(
                '${'version'.tr} ${AppBinding.find<AppInfoEntity>().formattedName}',
                style: AppTextStyle.message(context, bold: true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _closeDrawer(BuildContext context) {
    if (MediaQuery.of(context).size.width < 750) {
      Navigator.pop(context);
    }
  }
}
