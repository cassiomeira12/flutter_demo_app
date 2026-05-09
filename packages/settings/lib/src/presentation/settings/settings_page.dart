import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:settings/src/presentation/settings/settings.dart';
import 'package:settings/src/presentation/settings/widgets/widgets.dart';

class SettingsPage extends AppView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      title: 'settings'.tr,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
              child: Column(
                spacing: ResponsiveSizeHelper.spacingDefaultHeight,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: ResponsiveSizeHelper.maxWidth,
                    ),
                    child: Row(
                      spacing: ResponsiveSizeHelper.spacingDefaultWidth,
                      children: [
                        SizedBox(
                          width: ResponsiveSizeHelper.width(50),
                          height: ResponsiveSizeHelper.width(50),
                          child: ImageWidget(
                            imageUrl: controller.user.avatarUrl,
                          ),
                        ),
                        Flexible(
                          child: TextRichWidget(
                            children: [
                              TextRichWidget(
                                text: 'Olá, ',
                                style: AppTextStyle.message(context),
                              ),
                              TextRichWidget(
                                text: controller.user.firstName,
                                style: AppTextStyle.message(
                                  context,
                                  bold: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (AppRoutes.exist(AppRouter.user))
                    SecondaryButton(
                      key: const Key('settings_my_user_data_key'),
                      text: 'my_data'.tr,
                      expandWidth: true,
                      icon: const FlutterIcon(BoxIcons.bx_user),
                      onPressed: controller.userData,
                    ),
                  if (AppRoutes.exist(AppRouter.security))
                    SecondaryButton(
                      key: const Key('settings_security_key'),
                      text: 'security'.tr,
                      expandWidth: true,
                      icon: const FlutterIcon(BoxIcons.bx_building),
                      onPressed: controller.security,
                    ),
                  if (AppRoutes.exist(AppRouter.notificationsSettings))
                    SecondaryButton(
                      key: const Key('settings_notifications_key'),
                      text: 'notifications'.tr,
                      expandWidth: true,
                      icon: const FlutterIcon(BoxIcons.bxs_bell_ring),
                      onPressed: controller.notificationSettings,
                    ),
                  SecondaryButton(
                    key: const Key('settings_language_key'),
                    text: 'language'.tr,
                    expandWidth: true,
                    icon: const FlutterIcon(BoxIcons.bx_help_circle),
                    onPressed: () {
                      BottomSheetWidget.show(
                        context: context,
                        child: LocaleBottomSheetWidget(
                          onChangeLocale: controller.onChangeLocale,
                        ),
                      );
                    },
                  ),
                  SecondaryButton(
                    key: const Key('settings_themes_key'),
                    text: 'themes'.tr,
                    expandWidth: true,
                    icon: const FlutterIcon(BoxIcons.bx_brightness),
                    onPressed: controller.themes,
                  ),
                  if (AppRoutes.exist(AppRouter.about))
                    SecondaryButton(
                      key: const Key('settings_about_key'),
                      text: 'about'.tr,
                      expandWidth: true,
                      icon: const FlutterIcon(BoxIcons.bx_info_circle),
                      onPressed: controller.about,
                    ),
                  SecondaryButton(
                    key: const Key('settings_clear_cache_key'),
                    text: 'clear_local_cache'.tr,
                    expandWidth: true,
                    icon: const FlutterIcon(BoxIcons.bx_trash),
                    onPressed: () {
                      BottomSheetWidget.show(
                        context: context,
                        child: ClearCacheBottomSheetWidget(
                          onClearCache: controller.onClearCache,
                        ),
                      );
                    },
                  ),
                  if (!kReleaseMode)
                    SecondaryButton(
                      text: 'Debug crash',
                      expandWidth: true,
                      icon: const FlutterIcon(
                        BoxIcons.bx_bug,
                        color: Colors.black87,
                      ),
                      textColor: Colors.black87,
                      backgroundColor: StaticColors.debug,
                      onPressed: () {
                        CrashlyticsServiceManager.instance.simulateCrash();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).primaryColor,
                            content: const TextWidget('Debug crash sent'),
                          ),
                        );
                      },
                    ),
                  const SpacerWidget(height: 2),
                  FutureButton(
                    key: const Key('settings_logout_key'),
                    text: 'logout'.tr,
                    expandWidth: true,
                    onValidation: () async {
                      final bool? result = await DialogWidget.showChoice(
                        context,
                        title: 'logout'.tr,
                        message: 'logout_app_message'.tr,
                        okButton: 'logout'.tr,
                      );
                      return result ?? false;
                    },
                    onPressed: controller.logout,
                  ),
                  const SpacerWidget(height: 3),
                  TextWidget(
                    '${'version'.tr} ${controller.appInfo.formattedName}',
                    style: AppTextStyle.message(context, bold: true),
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
