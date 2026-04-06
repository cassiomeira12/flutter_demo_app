import 'package:clean_code_data/clean_code_data.dart';

class IpAddressLocationDataSourceImpl
    with ReadDtaSourceMixin
    implements IpAddressLocationDataSource {
  final HttpClient _http;

  IpAddressLocationDataSourceImpl({required HttpClient http}) : _http = http;

  @override
  Future<Map<String, dynamic>> getIpAddress({String? ip}) async {
    String endpoint = EndpointsEnum.ipLocation.endpoint;
    if (ip != null) endpoint += '/$ip';

    final request = HttpRequest(
      url: endpoint,
    );

    return await mixinRead(
      http: _http,
      request: request,
      defaultJsonKeys: [],
    );
  }
}
