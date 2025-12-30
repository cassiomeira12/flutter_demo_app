import 'package:core/core.dart';

class AboutController extends BaseController {
  final OpenWebUrlUseCase _openWebUrlUseCase;

  AboutController({required OpenWebUrlUseCase openWebUrlUseCase})
    : _openWebUrlUseCase = openWebUrlUseCase;

  bool get showOpenWebSiteButton {
    const String webAppUrl = String.fromEnvironment('web_app_url');
    return webAppUrl.isNotEmpty;
  }

  void appWhatsNew() {
    clickTagging(component: 'about_app_whats_new_key');
    AppNavigator.toNamed(AppRouter.updated);
  }

  void privacyPolicy() {
    clickTagging(component: 'about_privacy_policy_key');
    const serverUrl = String.fromEnvironment('server_url');
    const String url = '$serverUrl/privacy-policy';
    _openWebUrlUseCase.call(url);
  }

  void termsConditions() {
    clickTagging(component: 'about_terms_conditions_key');
    const serverUrl = String.fromEnvironment('server_url');
    const String url = '$serverUrl/terms-conditions';
    _openWebUrlUseCase.call(url);
  }

  void openWebSite() {
    clickTagging(component: 'about_open_website_key');
    const String webAppUrl = String.fromEnvironment('web_app_url');
    _openWebUrlUseCase.call(webAppUrl);
  }
}
