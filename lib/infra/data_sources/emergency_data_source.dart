import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';

class EmergencyDataSourceImpl implements EmergencyDataSource {
  final HttpClient _http;

  EmergencyDataSourceImpl({
    required HttpClient http,
  }) : _http = http;

  @override
  Future<bool> isAvailable() async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.isWhatsAppAvailable.endpoint,
      );

      final response = await _http.post(request);

      final Map<String, dynamic> json = response.data!;

      final Map<String, dynamic> result = json['result'];

      return result['status'] ?? false;
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<int> sendSOS({
    required int choice,
    required double latitude,
    required double longitude,
    required int accuracy,
  }) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.sendSOS.endpoint,
        data: {
          'choice': choice,
          'latitude': latitude,
          'longitude': longitude,
          'accuracy': accuracy,
        },
      );

      final response = await _http.post(request);

      final Map<String, dynamic> json = response.data!;

      final Map<String, dynamic> result = json['result'];

      final int contactSent = result['contactSent']
          .toString()
          .split(',')
          .length;

      return contactSent;
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> listHistory() async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.listUserOccurrencies.endpoint,
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
  Future<Map<String, dynamic>> changeSOSConfig({
    required bool onlyPolice,
    required bool onlySafetyContacts,
  }) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.changeSOSConfig.endpoint,
        data: {
          'onlyPolice': onlyPolice,
          'onlySafetyContacts': onlySafetyContacts,
        },
      );

      final response = await _http.post(request);

      final Map<String, dynamic> json = response.data!;

      final Map<String, dynamic> result = json['result'];

      return result;
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
