import 'package:clean_code_data/clean_code_data.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/data/data.dart';

class WhatsAppDataSourceImpl implements WhatsAppDataSource {
  final HttpClient _http;

  WhatsAppDataSourceImpl({required this._http});

  @override
  Future<void> sendWhatsAppCode({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.sendWhatsAppCode.endpoint,
        data: {
          'phoneNumber': phoneNumber,
          'code': code,
        },
      );

      await _http.post(request);
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
