import 'package:clean_code_data/clean_code_data.dart';
import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';

class SafetyContactDataSourceImpl implements SafetyContactDataSource {
  final HttpClient _http;

  SafetyContactDataSourceImpl({required this._http});

  @override
  Future<Map<String, dynamic>> create({
    required String name,
    required String phoneNumber,
    required bool sendMessage,
  }) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.createSafetyContact.endpoint,
        data: {
          'name': name,
          'phoneNumber': phoneNumber,
          'sendMessage': sendMessage,
        },
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      return json['result'] as Map<String, dynamic>;
    } on HttpException catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> list(int page) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.listSafetyContact.endpoint,
        data: {
          'page': page,
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
  Future<bool> delete(String objectId) async {
    try {
      final request = HttpRequest(
        url: EndpointsEnum.deleteSafetyContact.endpoint,
        data: {
          'objectId': objectId,
        },
      );

      final response = await _http.post<Map<String, dynamic>>(request);

      final Map<String, dynamic> json = response.data!;

      return json['result'] as bool;
    } on HttpException catch (_) {
      rethrow;
    }
  }
}
