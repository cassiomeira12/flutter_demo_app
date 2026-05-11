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
        url: EndpointsEnum.listCurrentPoints.endpoint,
        data: {
          'month': month,
          'year': year,
        },
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      return List.from(json['result'] ?? []).map((item) {
        return item as Map<String, dynamic>;
      }).toList();
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> registerPoint() async {
    try {
      final request = HttpRequest(url: EndpointsEnum.registerPoint.endpoint);

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
        url: EndpointsEnum.totalCurrentMonth.endpoint,
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      final Map<String, dynamic> result = json['result'];

      return result['totalFormatted'];
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
