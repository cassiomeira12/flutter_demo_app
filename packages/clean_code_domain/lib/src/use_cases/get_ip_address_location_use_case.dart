import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetIpAddressLocationUseCase
    extends BaseUseCaseAsyncParam<IpAddressLocationEntity, String?> {}

class GetIpAddressLocationUseCaseImpl implements GetIpAddressLocationUseCase {
  final IpAddressLocationService _service;

  GetIpAddressLocationUseCaseImpl({
    required IpAddressLocationService ipAddressLocationService,
  }) : _service = ipAddressLocationService;

  @override
  Future<IpAddressLocationEntity> call(String? ip) {
    return _service.getIpAddress(ip: ip);
  }
}
