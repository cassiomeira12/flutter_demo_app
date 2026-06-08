import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetOtpCodeUseCase extends BaseUseCaseSyncParam<String, String> {}

class GetOtpCodeUseCaseImpl implements GetOtpCodeUseCase {
  final OtpCodeService _service;

  GetOtpCodeUseCaseImpl({
    required OtpCodeService otpCodeService,
  }) : _service = otpCodeService;

  @override
  String call(String secret) {
    return _service.generateTOTPCode(secret);
  }
}
