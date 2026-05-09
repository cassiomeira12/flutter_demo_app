// ignore_for_file: join_return_with_assignment

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class WebController extends BaseController {
  final AppEnvironmentEntity _appEnv;
  final ServerEnvironmentEntity _serverEnv;
  final WebAppEnvironmentEntity _webAppEnv;
  final OpenWebUrlUseCase _openWebUrlUseCase;
  final GetDeviceLocaleUseCase _currentDeviceLocaleUseCase;

  WebController({
    required AppEnvironmentEntity appEnv,
    required ServerEnvironmentEntity serverEnv,
    required WebAppEnvironmentEntity webAppEnv,
    required OpenWebUrlUseCase openWebUrlUseCase,
    required GetDeviceLocaleUseCase currentDeviceLocaleUseCase,
  }) : _appEnv = appEnv,
       _serverEnv = serverEnv,
       _webAppEnv = webAppEnv,
       _openWebUrlUseCase = openWebUrlUseCase,
       _currentDeviceLocaleUseCase = currentDeviceLocaleUseCase;

  Rxn<UserEntity> user = Rxn();

  GlobalKey mainKey = GlobalKey();
  GlobalKey featuresKey = GlobalKey();
  GlobalKey downloadKey = GlobalKey();
  GlobalKey aboutKey = GlobalKey();
  GlobalKey contactsKey = GlobalKey();
  ScrollController? scrollController;

  String get appName => _appEnv.appName;

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
      if (session.isAuthenticated) {
        AppNavigator.backAllAndToNamed(AppRouter.home);
        return;
      }
    }
    AppNavigator.toNamed(AppRouter.login);
  }

  void privacyPolicy() {
    clickTagging(component: 'privacy_policy_footer_key');
    final serverUrl = _serverEnv.serverUrl;
    final String url = '$serverUrl/privacy-policy';
    _openWebUrlUseCase.call(url);
  }

  void termsConditions() {
    clickTagging(component: 'terms_conditions_footer_key');
    final serverUrl = _serverEnv.serverUrl;
    final String url = '$serverUrl/terms-conditions';
    _openWebUrlUseCase.call(url);
  }

  void helpAndSupport() {
    clickTagging(component: 'help_and_support_footer_key');
  }

  bool get showEmail => _webAppEnv.contactEmail.isNotEmpty;
  bool get showInstagramButton => _webAppEnv.contactInstagram.isNotEmpty;
  bool get showFacebookButton => _webAppEnv.contactFacebook.isNotEmpty;
  bool get showWhatsAppButton => _webAppEnv.contactWhatsApp.isNotEmpty;

  void openInstagram() {
    clickTagging(component: 'open_instagram_contacts_key');
    _openWebUrlUseCase.call(_webAppEnv.contactInstagram);
  }

  void openFacebook() {
    clickTagging(component: 'open_facebook_contacts_key');
    _openWebUrlUseCase.call(_webAppEnv.contactFacebook);
  }

  void openWhatsApp() {
    clickTagging(component: 'open_whatsapp_contacts_key');
    _openWebUrlUseCase.call(_webAppEnv.contactWhatsApp);
  }

  Future<void> downloadAndroidApp() async {
    clickTagging(component: 'download_google_store_key');

    final featureFlag = await FeatureFlagServiceManager.instance.getFlag<bool>(
      RemoteFlagsEnum.downloadAndroidStore,
    );
    final bool downloadFromStore =
        featureFlag.isEnabled && featureFlag.value == true;

    late String url;

    if (downloadFromStore) {
      final androidPackageName = _appEnv.androidPackageName;
      final locale = await _currentDeviceLocaleUseCase.call();
      final currentLanguage = locale.toLanguageTag();
      url =
          'https://play.google.com/store/apps/details?id=$androidPackageName&hl=$currentLanguage';
    } else {
      final serverUrl = _serverEnv.serverUrl;
      url = '$serverUrl/download_android_app';
    }

    _openWebUrlUseCase.call(url);
  }

  Future<void> downloadAppleApp() async {
    clickTagging(component: 'download_apple_store_key');

    final featureFlag = await FeatureFlagServiceManager.instance.getFlag<bool>(
      RemoteFlagsEnum.downloadAppleStore,
    );
    final bool downloadFromStore =
        featureFlag.isEnabled && featureFlag.value == true;

    late String url;

    if (downloadFromStore) {
      final appAppleId = _appEnv.appleStoreAppId;
      url = 'https://apps.apple.com/br/app/$appAppleId';
    } else {
      final serverUrl = _serverEnv.serverUrl;
      url = '$serverUrl/download_ios_app';
    }

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
