import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:security/src/domain/domain.dart';

class LocalAuthServiceImpl implements LocalAuthService {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Future<bool> authenticate() async {
    try {
      await auth.stopAuthentication();
      return await auth.authenticate(
        localizedReason: ' ',
        authMessages: [
          AndroidAuthMessages(
            // signInTitle: const String.fromEnvironment('app_name'),
            signInHint: 'biometrics_authenticate_message'.tr,
            cancelButton: 'cancel'.tr,
          ),
        ],
      );
    } on PlatformException {
      return false;
    } on LocalAuthException catch (error, stackTrace) {
      switch (error.code) {
        case LocalAuthExceptionCode.authInProgress:
        case LocalAuthExceptionCode.uiUnavailable:
        case LocalAuthExceptionCode.userCanceled:
        case LocalAuthExceptionCode.timeout:
        case LocalAuthExceptionCode.systemCanceled:
          return false;
        case LocalAuthExceptionCode.noCredentialsSet:
        case LocalAuthExceptionCode.noBiometricsEnrolled:
        case LocalAuthExceptionCode.noBiometricHardware:
        case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
        case LocalAuthExceptionCode.temporaryLockout:
        case LocalAuthExceptionCode.biometricLockout:
        case LocalAuthExceptionCode.userRequestedFallback:
        case LocalAuthExceptionCode.deviceError:
        case LocalAuthExceptionCode.unknownError:
          Log.error(error, stackTrace);
          return false;
      }
    } catch (error, stackTrace) {
      Log.error(error, stackTrace, msg: 'authenticate: Unexpected Exception');
      return false;
    }
  }

  @override
  Future<bool> isDeviceSupported() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      return canAuthenticate;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace, msg: 'authenticate: Unexpected Exception');
      return false;
    }
  }
}
