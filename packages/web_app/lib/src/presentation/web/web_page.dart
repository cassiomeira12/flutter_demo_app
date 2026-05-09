import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:web_app/src/presentation/web/web.dart';
import 'package:web_app/src/presentation/web/widgets/widgets.dart';

class WebPage extends AppView<WebController> {
  const WebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      endDrawer: MediaQuery.of(context).size.width > 800
          ? null
          : DrawerWebWidget(
              children: [
                const SpacerWidget(height: 5),
                FlatButton(
                  key: const Key('scroll_features_drawer_key'),
                  text: 'features_web_nav_bar'.tr,
                  expandWidth: true,
                  onPressed: () {
                    controller.scrollToFeatures(
                      context,
                      component: 'scroll_features_drawer_key',
                    );
                  },
                ),
                FlatButton(
                  key: const Key('scroll_download_drawer_key'),
                  text: 'download_web_nav_bar'.tr,
                  expandWidth: true,
                  onPressed: () {
                    controller.scrollToDownload(
                      context,
                      component: 'scroll_download_drawer_key',
                    );
                  },
                ),
                FlatButton(
                  key: const Key('scroll_about_drawer_key'),
                  text: 'about_web_nav_bar'.tr,
                  expandWidth: true,
                  onPressed: () {
                    controller.scrollToAbout(
                      context,
                      component: 'scroll_about_drawer_key',
                    );
                  },
                ),
                FlatButton(
                  key: const Key('scroll_contacts_drawer_key'),
                  text: 'contact_web_nav_bar'.tr,
                  expandWidth: true,
                  onPressed: () {
                    controller.scrollToContacts(
                      context,
                      component: 'scroll_contacts_drawer_key',
                    );
                  },
                ),
                FlatButton(
                  key: const Key('login_drawer_key'),
                  text: 'login'.tr,
                  expandWidth: true,
                  onPressed: () {
                    controller.login(context, component: 'login_drawer_key');
                  },
                ),
              ],
            ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ScrollViewWidget(
            child: (scrollController) {
              controller.scrollController = scrollController;
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    MainCardWidget(key: controller.mainKey),
                    FeaturesCardWidget(key: controller.featuresKey),
                    DownloadCardWidget(key: controller.downloadKey),
                    AboutCardWidget(key: controller.aboutKey),
                    ContactCardWidget(key: controller.contactsKey),
                    const FooterWidget(),
                  ],
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
            child: AppBarWidget(
              title: null,
              titleWidget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    key: const Key('scroll_logo_top_app_bar_key'),
                    onTap: controller.scrollToTop,
                    splashColor: Colors.transparent,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: ResponsiveSizeHelper.width(30),
                          height: ResponsiveSizeHelper.width(30),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(AppAssets.logo),
                            ),
                          ),
                        ),
                        const SpacerWidget(),
                        TextWidget(
                          controller.appName,
                          style: AppTextStyle.subtitle(context),
                        ),
                      ],
                    ),
                  ),
                  if (MediaQuery.of(context).size.width > 800)
                    Expanded(
                      child: Row(
                        children: [
                          Theme(
                            data: ThemeData.light(),
                            child: Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LightButton(
                                    key: const Key(
                                      'scroll_features_app_bar_key',
                                    ),
                                    text: 'features_web_nav_bar'.tr,
                                    onPressed: () {
                                      controller.scrollToFeatures(
                                        context,
                                        component:
                                            'scroll_features_app_bar_key',
                                      );
                                    },
                                  ),
                                  LightButton(
                                    key: const Key(
                                      'scroll_download_app_bar_key',
                                    ),
                                    text: 'download_web_nav_bar'.tr,
                                    onPressed: () {
                                      controller.scrollToDownload(
                                        context,
                                        component:
                                            'scroll_download_app_bar_key',
                                      );
                                    },
                                  ),
                                  LightButton(
                                    key: const Key('scroll_about_app_bar_key'),
                                    text: 'about_web_nav_bar'.tr,
                                    onPressed: () {
                                      controller.scrollToAbout(
                                        context,
                                        component: 'scroll_about_app_bar_key',
                                      );
                                    },
                                  ),
                                  LightButton(
                                    key: const Key(
                                      'scroll_contacts_app_bar_key',
                                    ),
                                    text: 'contact_web_nav_bar'.tr,
                                    onPressed: () {
                                      controller.scrollToContacts(
                                        context,
                                        component:
                                            'scroll_contacts_app_bar_key',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(() {
                            if (controller.user.value != null) {
                              return InkWell(
                                child: SizedBox(
                                  width: ResponsiveSizeHelper.width(35),
                                  height: ResponsiveSizeHelper.width(35),
                                  child: ImageWidget(
                                    imageUrl:
                                        controller.user.value?.avatarUrl ?? '',
                                  ),
                                ),
                                onTap: () => controller.login(
                                  context,
                                  component: 'login_app_bar_logged_key',
                                ),
                              );
                            } else {
                              return PrimaryButton(
                                key: const Key('login_app_bar_key'),
                                text: 'login'.tr,
                                size: ButtonSize.small,
                                onPressed: () => controller.login(
                                  context,
                                  component: 'login_app_bar_key',
                                ),
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
