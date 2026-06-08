import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppsflyerServiceImpl implements AppsFlyerService {
  final String _afDevKey;
  final String _appleStoreAppId;

  AppsflyerServiceImpl({
    required this._afDevKey,
    required this._appleStoreAppId,
  });

  AppsflyerSdk? _appsflyerSdk;

  @override
  Future<void> init() async {
    final appsFlyerOptions = AppsFlyerOptions(
      afDevKey: _afDevKey,
      appId: _appleStoreAppId,
      showDebug: true,
      timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
      // appInviteOneLink: oneLinkID, // Optional field
      disableAdvertisingIdentifier: true, // Optional field
      disableCollectASA: true, //Optional field
      manualStart: true,
    );

    _appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

    try {
      await _appsflyerSdk?.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );

      // print('appsflyer $result');

      // _appsflyerSdk?.getSDKVersion().then((value) {
      //   print('appsflyer getSDKVersion $value');
      // });

      // _appsflyerSdk?.getHostName().then((value) {
      //   print('appsflyer getHostName $value');
      // });

      // _appsflyerSdk?.getHostPrefix().then((value) {
      //   print('appsflyer getHostPrefix $value');
      // });

      // _appsflyerSdk?.getAppsFlyerUID().then((value) {
      //   print('appsflyer getAppsFlyerUID $value');
      // });

      // _appsflyerSdk?.getOutOfStore().then((value) {
      //   print('appsflyer getOutOfStore $value');
      // });

      // _appsflyerSdk?.onInstallConversionData((res) {
      //   print("appsflyer onInstallConversionData res: $res");
      // });

      // // App open attribution callback
      // _appsflyerSdk?.onAppOpenAttribution((res) {
      //   print("appsflyer onAppOpenAttribution res: $res");
      // });

      _appsflyerSdk?.startSDK(
        onSuccess: () {
          // timer.cancel();
          Log.success('$runtimeType init successful', throwsCrashlytics: false);
          // completer.complete();
        },
        onError: (int errorCode, String errorMessage) {
          Log.error(
            '$runtimeType init ERROR $errorCode - $errorMessage',
            StackTrace.current,
            throwsCrashlytics: false,
          );
          // completer.completeError('$runtimeType init ERROR');
        },
      );
    } catch (error, stackTrace) {
      // timer.cancel();
      Log.error(error, stackTrace, msg: '$runtimeType init ERROR');
      // completer.completeError('$runtimeType init ERROR');
    }

    // return completer.future;
  }

  // void afterInstall() {
  //   _appsflyerSdk?.onInstallConversionData((res) {
  //     print("res: " + res.toString());
  //   });
  // }

  @override
  Future<void> setUserId(String userId) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) async {}

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {}

  @override
  void deeplink() {
    _appsflyerSdk?.onAppOpenAttribution((res) {
      debugPrint('res: $res');
    });

    _appsflyerSdk?.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          debugPrint(dp.deepLink?.toString());
          debugPrint('deep link value: ${dp.deepLink?.deepLinkValue}');
        case Status.NOT_FOUND:
          debugPrint('deep link not found');
        case Status.ERROR:
          debugPrint('deep link error: ${dp.error}');
        case Status.PARSE_ERROR:
          debugPrint('deep link status parsing error');
      }
    });
  }
}
