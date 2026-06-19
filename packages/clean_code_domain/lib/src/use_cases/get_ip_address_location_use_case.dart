import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetIpAddressLocationUseCase
    extends BaseUseCaseAsyncParam<IpAddressLocationEntity, String?> {}

class GetIpAddressLocationUseCaseImpl implements GetIpAddressLocationUseCase {
  final IpAddressLocationService _ipAddressLocationService;

  GetIpAddressLocationUseCaseImpl({required this._ipAddressLocationService});

  @override
  Future<IpAddressLocationEntity> call(String? ip) {
    return _ipAddressLocationService.getIpAddress(ip: ip);
  }
}
