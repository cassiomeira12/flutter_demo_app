import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:faq/src/domain/domain.dart';

class AboutController extends BaseController {
  final OpenWebUrlUseCase _openWebUrlUseCase;
  final AppReviewUseCase _appReviewUseCase;

  AboutController({
    required this._openWebUrlUseCase,
    required this._appReviewUseCase,
  });

  bool get showOpenWebSiteButton {
    const String webAppUrl = String.fromEnvironment('web_app_url');
    return webAppUrl.isNotEmpty;
  }

  Future<void> appReview() async {
    final bool isAvailable = await _appReviewUseCase.isAvailable();
    if (isAvailable) {
      await _appReviewUseCase.requestReview();
    } else {
      throw BaseException(message: 'your_device_has_no_support_to_review');
    }
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

  void feedback() {
    clickTagging(component: 'about_feedback_key');
    AppNavigator.toNamed(AppRouter.feedback);
  }
}
