import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetOtpCodeUseCase extends BaseUseCaseSyncParam<String, String> {}

class GetOtpCodeUseCaseImpl implements GetOtpCodeUseCase {
  final OtpCodeService _otpCodeService;

  GetOtpCodeUseCaseImpl({required this._otpCodeService});

  @override
  String call(String secret) {
    return _otpCodeService.generateTOTPCode(secret);
  }
}
