import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class GetOtpCodeUseCaseImpl implements GetOtpCodeUseCase {
  @override
  String call({required String secret}) {
    final String code = OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      isGoogle: true,
      algorithm: Algorithm.SHA1,
    );
    return code;
  }
}
