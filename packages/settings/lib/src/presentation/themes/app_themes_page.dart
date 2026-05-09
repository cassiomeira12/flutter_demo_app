import 'package:core/core.dart' hide ThemeController;
import 'package:dependency/dependency.dart';
import 'package:settings/src/presentation/themes/app_themes_controller.dart';
import 'package:settings/src/presentation/themes/widgets/widgets.dart';

class AppThemesPage extends AppView<AppThemesController> {
  const AppThemesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'themes'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: ResponsiveSizeHelper.maxWidth,
              ),
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
              child: Column(
                spacing: ResponsiveSizeHelper.spacingDefaultHeight,
                children: [
                  SecondaryButton(
                    key: const Key('settings_theme_key'),
                    text: 'theme'.tr,
                    expandWidth: true,
                    icon: const FlutterIcon(BoxIcons.bx_brightness),
                    onPressed: () {
                      BottomSheetWidget.show(
                        context: context,
                        child: ThemeBottomSheetWidget(
                          currentThemeData: controller.currentThemeData,
                          onChangeTheme: controller.onChangeTheme,
                        ),
                      );
                    },
                  ),
                  const SpacerWidget(),
                  TextWidget(
                    'launcher_icon'.tr,
                    style: AppTextStyle.subtitle(context),
                  ),
                  Wrap(
                    spacing: ResponsiveSizeHelper.spacingDefaultWidth,
                    runSpacing: ResponsiveSizeHelper.spacingDefaultHeight,
                    children: controller.iconsAvailable().map((
                      icon,
                    ) {
                      return Obx(() {
                        return InkWell(
                          onTap: () async {
                            if (!controller.supportsAlternateIcons.value) {
                              DialogWidget.show(
                                context,
                                title: '',
                                message: 'device_not_supported'.tr,
                              );
                              return;
                            }
                            if (controller.currentAppIcon.value != icon.name) {
                              final result = await controller.setIcon(
                                icon.name,
                              );
                              if (Platform.isAndroid && result is Success) {
                                if (!context.mounted) return;
                                await DialogWidget.show(
                                  context,
                                  title: 'change_launcher_icon'.tr,
                                  message: 'need_restart_the_app'.tr,
                                );
                              }
                              if (result is Error) {
                                if (!context.mounted) return;
                                DialogWidget.show(
                                  context,
                                  title: 'error'.tr,
                                  message: result.error.message.tr,
                                );
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: ResponsiveSizeHelper.width(120),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:
                                  controller.currentAppIcon.value == icon.name
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).highlightColor,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LayoutBuilder(
                                  builder: (_, constraints) {
                                    return Container(
                                      height: ResponsiveSizeHelper.width(
                                        constraints.maxWidth,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).highlightColor,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(icon.path),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SpacerWidget(),
                                TextWidget(
                                  icon.name,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.message(
                                    context,
                                    color:
                                        controller.currentAppIcon.value ==
                                            icon.name
                                        ? Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    }).toList(),
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
