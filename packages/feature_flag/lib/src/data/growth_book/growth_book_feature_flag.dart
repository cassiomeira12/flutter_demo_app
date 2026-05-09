import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:feature_flag/src/data/mixin/parse_value_mixin.dart';

class GrowthBookFeatureFlag with ParseValueMixin implements FeatureFlagService {
  final String _apiKey;
  final String _hostUrl;

  GrowthBookFeatureFlag({
    required String apiKey,
    required String hostUrl,
  }) : _apiKey = apiKey,
       _hostUrl = hostUrl;

  GrowthBookSDK? _sdk;

  @override
  Future<void> init() async {
    final config = GBSDKBuilderApp(
      apiKey: _apiKey,
      hostURL: _hostUrl,
      // attributes: {
      //   'version': '1.4.2',
      // },
      growthBookTrackingCallBack: (GBTrackData trackData) {
        Log.info(
          'GrowthBook Feature Flag \n'
          '${trackData.experiment.toJson()} \n'
          '\n'
          '${trackData.experimentResult.toJson()} \n',
        );
      },
      onInitializationFailure: (GBError? error) {
        Log.error(
          error?.error ?? 'GrowthBookFeatureFlag init',
          error?.stackTrace == null
              ? StackTrace.current
              : StackTrace.fromString(error!.stackTrace),
          msg: 'GrowthBook Feature Flag',
        );
      },
    );

    _sdk = await config.initialize();
  }

  @override
  Future<RemoteFlag<T>> getFlag<T>(
    RemoteFlagsEnum flag, {
    bool reload = false,
  }) async {
    final feature = _sdk?.feature(flag.name);
    return parseValueType<T>(
      flag: flag,
      isEnabled: feature?.on ?? false,
      value: feature?.value,
    );
  }

  @override
  Future<void> setTraits(DeviceTraits traits) async {
    Log.info(
      'GrowthBook Feature Flag setTraits\n'
      '${traits.toMap()}',
    );
    _sdk?.setAttributes(traits.toMap());
  }

  @override
  void setUserId(String? userId) {
    final properties = {'userId': userId};
    Log.info(
      'GrowthBook Feature Flag setUserIdentifier\n'
      '$properties',
    );
    _sdk?.setAttributes(properties);
  }
}
