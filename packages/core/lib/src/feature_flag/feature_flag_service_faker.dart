import 'package:core/core.dart';

class FeatureFlagServiceFaker implements FeatureFlagService {
  @override
  Future<void> init({Map<String, dynamic>? initConfigs}) async {
    Log.success(
      '$runtimeType init initiConfigs: $initConfigs',
      throwsCrashlytics: false,
    );
  }

  @override
  Future<RemoteFlag?> getFlag(
    RemoteFlagsEnum flag, {
    bool reload = false,
  }) async {
    Log.info('getFlag flagh: $flag');
    return null;
  }

  @override
  Future<void> setTraits(DeviceTraits traits) async {
    Log.info('setTraits traits: ${traits.toMap()}');
  }

  @override
  void setUserIdentifier(String? userId, {Map<String, dynamic>? property}) {
    Log.info('setUserIdentifier userId: $userId property: $property');
  }
}
