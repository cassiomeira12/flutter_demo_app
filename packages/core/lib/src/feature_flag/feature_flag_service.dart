import 'package:core/core.dart';

abstract class FeatureFlagService {
  Future<void> init();

  void setUserIdentifier(String? userId, {Map<String, dynamic>? property});

  Future<void> setTraits(DeviceTraits traits);

  Future<RemoteFlag?> getFlag(RemoteFlagsEnum flag, {bool reload = false});
}
