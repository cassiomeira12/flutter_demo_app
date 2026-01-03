// ignore_for_file: join_return_with_assignment

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class WebController extends BaseController {
  final OpenWebUrlUseCase _openWebUrlUseCase;
  final GetDeviceLocaleUseCase _currentDeviceLocaleUseCase;

  WebController({
    required OpenWebUrlUseCase openWebUrlUseCase,
    required GetDeviceLocaleUseCase currentDeviceLocaleUseCase,
  }) : _openWebUrlUseCase = openWebUrlUseCase,
       _currentDeviceLocaleUseCase = currentDeviceLocaleUseCase;

  final EnvironmentEntity environment = AppBinding.find<EnvironmentEntity>();

  Rxn<UserEntity> user = Rxn();

  GlobalKey mainKey = GlobalKey();
  GlobalKey featuresKey = GlobalKey();
  GlobalKey downloadKey = GlobalKey();
  GlobalKey aboutKey = GlobalKey();
  GlobalKey contactsKey = GlobalKey();
  ScrollController? scrollController;

  @override
  Future<void> onReady() async {
    super.onReady();

    if (AppBinding.hasInstance<UserEntity>()) {
      user.value = AppBinding.find<UserEntity>();
    }
  }

  void _closeDrawer(BuildContext context) {
    if (MediaQuery.of(context).size.width < 750) {
      Navigator.pop(context);
    }
  }

  void scrollToTop() {
    clickTagging(component: 'scroll_logo_top_app_bar_key');
    scrollController!.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void scrollToFeatures(BuildContext context, {required String component}) {
    clickTagging(component: component);
    _closeDrawer(context);
    scrollController!.animateTo(
      _calculateHeightToScroll(featuresKey),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void scrollToDownload(BuildContext context, {required String component}) {
    clickTagging(component: component);
    _closeDrawer(context);
    scrollController!.animateTo(
      _calculateHeightToScroll(downloadKey),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void scrollToAbout(BuildContext context, {required String component}) {
    clickTagging(component: component);
    _closeDrawer(context);
    scrollController!.animateTo(
      _calculateHeightToScroll(aboutKey),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void scrollToContacts(BuildContext context, {required String component}) {
    clickTagging(component: component);
    _closeDrawer(context);
    scrollController!.animateTo(
      _calculateHeightToScroll(contactsKey),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void login(BuildContext context, {required String component}) {
    clickTagging(component: component);
    _closeDrawer(context);
    final bool hasInstance = AppBinding.hasInstance<SessionEntity>();
    if (hasInstance) {
      final session = AppBinding.find<SessionEntity>();
      if (session.token != null) {
        AppNavigator.backAllAndToNamed(AppRouter.home);
        return;
      }
    }
    AppNavigator.toNamed(AppRouter.login);
  }

  void privacyPolicy() {
    clickTagging(component: 'privacy_policy_footer_key');
    const serverUrl = String.fromEnvironment('server_url');
    const String url = '$serverUrl/privacy-policy';
    _openWebUrlUseCase.call(url);
  }

  void termsConditions() {
    clickTagging(component: 'terms_conditions_footer_key');
    const serverUrl = String.fromEnvironment('server_url');
    const String url = '$serverUrl/terms-conditions';
    _openWebUrlUseCase.call(url);
  }

  void helpAndSupport() {
    clickTagging(component: 'help_and_support_footer_key');
  }

  bool get showEmail =>
      const String.fromEnvironment('web_contact_email').isNotEmpty;

  bool get showInstagramButton =>
      const String.fromEnvironment('web_contact_instagram').isNotEmpty;

  bool get showFacebookButton =>
      const String.fromEnvironment('web_contact_facebook').isNotEmpty;

  bool get showWhatsAppButton =>
      const String.fromEnvironment('web_contact_whatsapp').isNotEmpty;

  void openInstagram() {
    clickTagging(component: 'open_instagram_contacts_key');
    final link = const String.fromEnvironment('web_contact_instagram');
    _openWebUrlUseCase.call(link);
  }

  void openFacebook() {
    clickTagging(component: 'open_facebook_contacts_key');
    final link = const String.fromEnvironment('web_contact_facebook');
    _openWebUrlUseCase.call(link);
  }

  void openWhatsApp() {
    clickTagging(component: 'open_whatsapp_contacts_key');
    final link = const String.fromEnvironment('web_contact_whatsapp');
    _openWebUrlUseCase.call(link);
  }

  Future<void> downloadAndroidApp() async {
    clickTagging(component: 'download_google_store_key');
    const androidPackageName = String.fromEnvironment('android_package_name');
    final locale = await _currentDeviceLocaleUseCase.call();
    final currentLanguage = locale.toLanguageTag();
    final String url =
        'https://play.google.com/store/apps/details?id=$androidPackageName&hl=$currentLanguage';
    _openWebUrlUseCase.call(url);
  }

  void downloadAppleApp() {
    clickTagging(component: 'download_apple_store_key');
    const appAppleId = String.fromEnvironment('apple_store_app_id');
    final String url = 'https://apps.apple.com/br/app/$appAppleId';
    _openWebUrlUseCase.call(url);
  }

  double _calculateHeightToScroll(GlobalKey key) {
    double itemHeight = -100;

    if (key == mainKey) {
      return itemHeight;
    }

    RenderBox? renderBox;

    renderBox = mainKey.currentContext?.findRenderObject() as RenderBox?;
    itemHeight += renderBox?.size.height ?? 0;

    if (key == featuresKey) {
      return itemHeight;
    }

    renderBox = featuresKey.currentContext?.findRenderObject() as RenderBox?;
    itemHeight += renderBox?.size.height ?? 0;

    if (key == downloadKey) {
      return itemHeight;
    }

    renderBox = downloadKey.currentContext?.findRenderObject() as RenderBox?;
    itemHeight += renderBox?.size.height ?? 0;

    if (key == aboutKey) {
      return itemHeight;
    }

    renderBox = aboutKey.currentContext?.findRenderObject() as RenderBox?;
    itemHeight += renderBox?.size.height ?? 0;

    return itemHeight;
  }
}
