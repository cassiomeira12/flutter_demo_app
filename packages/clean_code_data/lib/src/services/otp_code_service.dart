import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class OtpCodeServiceImpl implements OtpCodeService {
  @override
  String generateTOTPCode(String secret) {
    final String code = OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      isGoogle: true,
      algorithm: Algorithm.SHA1,
    );
    return code;
  }
}
