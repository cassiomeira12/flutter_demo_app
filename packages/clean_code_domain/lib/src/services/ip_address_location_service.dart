import 'package:clean_code_domain/clean_code_domain.dart';

abstract class IpAddressLocationService {
  Future<IpAddressLocationEntity> getIpAddress({String? ip});
}
