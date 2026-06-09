import 'package:clean_code_data/clean_code_data.dart';

class IpAddressLocationDataSourceImpl
    with ReadDtaSourceMixin
    implements IpAddressLocationDataSource {
  final HttpClient _http;

  IpAddressLocationDataSourceImpl({required this._http});

  @override
  Future<Map<String, dynamic>> getIpAddress({String? ip}) async {
    final request = HttpRequest(
      url: EndpointsEnum.ipLocation.endpoint,
      data: {
        'ip': ip,
      },
    );

    return await mixinRead(
      http: _http,
      request: request,
      method: HttpMethod.POST,
    );
  }
}
