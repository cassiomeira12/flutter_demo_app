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

  @override
  Future<Map<String, dynamic>> updateWorkDay({
    required int day,
    required int month,
    required int year,
    bool allowance = false,
    bool holiday = false,
    bool dayOff = false,
    required String info,
  }) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.updateWorkDay.endpoint,
        data: {
          'day': day,
          'month': month,
          'year': year,
          'allowance': allowance,
          'holiday': holiday,
          'dayOff': dayOff,
          'info': info,
        },
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      final Map<String, dynamic> result = json['result'];

      return result;
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateWorkPoint(
    String objectId, {
    required String? time,
  }) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.updateWorkPoint.endpoint,
        data: {
          'workPointId': objectId,
          'time': time,
        },
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      final Map<String, dynamic> result = json['result'];

      return result;
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> registerCustomPoint({
    required int day,
    required int month,
    required int year,
    required String? time,
  }) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.updateWorkPoint.endpoint,
        data: {
          'day': day,
          'month': month,
          'year': year,
          'time': time,
        },
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      final Map<String, dynamic> result = json['result'];

      return result;
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
