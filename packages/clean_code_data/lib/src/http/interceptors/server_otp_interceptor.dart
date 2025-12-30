import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ServerOtpInterceptor extends Interceptor {
  final GetOtpCodeUseCase _getOtpCodeUseCase;
  final EncryptServerPublicKeyUseCase _encryptServerUseCase;

  ServerOtpInterceptor({
    required GetOtpCodeUseCase getOtpCodeUseCase,
    required EncryptServerPublicKeyUseCase encryptServerPublicKeyUseCase,
  }) : _getOtpCodeUseCase = getOtpCodeUseCase,
       _encryptServerUseCase = encryptServerPublicKeyUseCase;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    const String secretOTP = String.fromEnvironment('server_secret_otp');
    final String code = _getOtpCodeUseCase.call(secret: secretOTP);
    final String encryptedCode = _encryptServerUseCase.call(code);

    if (code != encryptedCode) {
      options.headers.addAll({'Hash-Token-Code': encryptedCode});
    }

    super.onRequest(options, handler);
  }
}
