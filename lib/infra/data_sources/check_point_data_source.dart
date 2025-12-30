import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';

class CheckPointDataSourceImpl implements CheckPointDataSource {
  final HttpClient _http;

  CheckPointDataSourceImpl({
    required HttpClient http,
  }) : _http = http;

  @override
  Future<List<Map<String, dynamic>>> currentPoints({
    required int month,
    required int year,
  }) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.listCurrentPoints.endpoint
            .replaceFirst('{year}', year.toString())
            .replaceFirst('{month}', month.toString()),
      );

      final response = await _http.get<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      return List.from(json['diasLancamento'] ?? []).map((item) {
        return item as Map<String, dynamic>;
      }).toList();
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> registerPoint() async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.registerPoint.endpoint,
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Accept-Language': 'pt-BR',
          'Accept-Encoding': 'gzip, deflate, br, zstd',
          'Referer': 'https://app.beefor.io/',
          'Origin': 'https://app.beefor.io',
        },
      );

      await _http.post(request);
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<String> totalHours({
    required int month,
    required int year,
  }) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.totalCurrentMonth.endpoint
            .replaceFirst('{month}', month.toString())
            .replaceFirst('{year}', year.toString()),
      );

      final response = await _http.get<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      return json['horasTotaisFormatado'];
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
