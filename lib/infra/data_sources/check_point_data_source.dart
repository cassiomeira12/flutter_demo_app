import 'package:clean_code_data/clean_code_data.dart';
import 'package:flutter_demo_app/data/data.dart';

class CheckPointDataSourceImpl implements CheckPointDataSource {
  final HttpClient _http;

  CheckPointDataSourceImpl({required this._http});

  @override
  Future<List<Map<String, dynamic>>> currentPoints({
    required int month,
    required int year,
  }) async {
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
  }

  @override
  Future<void> registerPoint() async {
    final request = HttpRequest(url: EndpointsEnum.registerPoint.endpoint);
    await _http.post(request);
  }

  @override
  Future<String> totalHours({
    required int month,
    required int year,
  }) async {
    final request = HttpRequest(
      url: EndpointsEnum.totalCurrentMonth.endpoint,
    );

    final response = await _http.post<Map<String, dynamic>>(request);

    final Map<String, dynamic> json = response.data!;
    final Map<String, dynamic> result = json['result'];

    return result['totalFormatted'];
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
  }

  @override
  Future<Map<String, dynamic>> updateWorkPoint(
    String objectId, {
    required String? time,
  }) async {
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
  }

  @override
  Future<Map<String, dynamic>> registerCustomPoint({
    required int day,
    required int month,
    required int year,
    required String? time,
  }) async {
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
  }
}
