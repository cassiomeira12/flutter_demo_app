import 'package:core/core.dart';

mixin AnalyticsMixin {
  String get page => '$runtimeType'.replaceAll('Controller', 'Page');

  void appOpenedTagging() {
    tagging('app_open');
  }

  void appTerminateTagging() {
    tagging('app_terminate');
  }

  void appForegroundTagging({String? route}) {
    tagging(
      'app_foreground',
      parameters: {'screen_class': page, 'screen_name': route ?? ''},
    );
  }

  void appBackgroundTagging({String? route}) {
    tagging(
      'app_background',
      parameters: {'screen_class': page, 'screen_name': route ?? ''},
    );
  }

  void appResumedTagging({String? route}) {
    tagging(
      'app_resumed',
      parameters: {'screen_class': page, 'screen_name': route ?? ''},
    );
  }

  void appPausedTagging({String? route}) {
    tagging(
      'app_paused',
      parameters: {'screen_class': page, 'screen_name': route ?? ''},
    );
  }

  void onboardingBeginTagging() {
    tagging('tutorial_begin');
  }

  void onboardingCompleteTagging() {
    tagging('tutorial_complete');
  }

  void setUserIdentifier(String userId, {Map<String, dynamic>? property}) {
    AnalyticsServiceManager.instance.setUserId(userId);
    CrashlyticsServiceManager.instance.setUserId(userId);
    FeatureFlagServiceManager.instance.setUserIdentifier(userId);
    if (property != null) {
      final Map<String, dynamic> properties = {
        'userId': userId,
        'name': property['name'] ?? property['nome'] ?? '',
        'username': property['username'] ?? '',
        'email': property['email'] ?? '',
      };
      AnalyticsServiceManager.instance.setUserProperty(
        name: 'user_property',
        property: properties,
      );
      final String? userNameIdentifier =
          properties['name'] ?? property['nome'] ?? property['username'];
      CrashlyticsServiceManager.instance.setUserProperty(
        name: userNameIdentifier ?? '',
        property: properties,
      );
      FeatureFlagServiceManager.instance.setUserIdentifier(
        userId,
        property: properties,
      );
    }
  }

  void signupTagging() {
    tagging('sign_up');
  }

  void loginTagging() {
    tagging('login');
  }

  void logoutTagging() {
    tagging('logout');
  }

  void sessionExpiredTagging() {
    tagging('session_expired');
  }

  void screenTagging({String? route}) {
    tagging(
      'screen_view',
      parameters: {'screen_class': page, 'screen_name': route ?? ''},
    );
  }

  void clickTagging({String? route, String? component}) {
    tagging(
      'click',
      parameters: {
        'screen_class': page,
        'screen_name': route ?? '',
        'component': component ?? '',
      },
    );
  }

  void backTagging({String? route}) {
    tagging(
      'back',
      parameters: {'screen_class': page, 'screen_name': route ?? ''},
    );
  }

  void callbackTagging({String? route}) {
    tagging(
      'callback',
      parameters: {'screen_class': page, 'screen_name': route ?? ''},
    );
  }

  void tagging(String event, {Map<String, dynamic>? parameters}) {
    eventTagging(event, parameters: parameters);
  }

  static void eventTagging(String event, {Map<String, dynamic>? parameters}) {
    Log.debug(
      'Event: $event \n'
      'Page: ${parameters?['screen_class']} \n'
      'Parameters: $parameters',
    );
    AnalyticsServiceManager.instance.logEvent(
      name: event,
      parameters: parameters,
    );
  }
}
