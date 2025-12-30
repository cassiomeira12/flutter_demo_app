import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppsflyerServiceImpl implements AppsFlyerService {
  final String _afDevKey;
  final String _appleStoreAppId;

  AppsflyerServiceImpl({
    required String afDevKey,
    required String appleStoreAppId,
  }) : _afDevKey = afDevKey,
       _appleStoreAppId = appleStoreAppId;

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
            '$runtimeType init ERROR',
            error: '$errorCode - $errorMessage',
            throwsCrashlytics: false,
          );
          // completer.completeError('$runtimeType init ERROR');
        },
      );
    } catch (error, stackTrace) {
      // timer.cancel();
      Log.error(
        '$runtimeType init ERROR',
        error: error,
        stackTrace: stackTrace,
        throwsCrashlytics: false,
      );
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
      print("res: " + res.toString());
    });

    _appsflyerSdk?.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          print(dp.deepLink?.toString());
          print("deep link value: ${dp.deepLink?.deepLinkValue}");
          break;
        case Status.NOT_FOUND:
          print("deep link not found");
          break;
        case Status.ERROR:
          print("deep link error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          print("deep link status parsing error");
          break;
      }
    });
  }
}
