abstract class LocalAuthService {
  Future<bool> isDeviceSupported();

  Future<bool> authenticate();
}
