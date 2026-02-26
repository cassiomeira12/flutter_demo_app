import 'package:clean_code_data/clean_code_data.dart';

class BaseCrudDataSourceMixin
    with
        CreateDataSourceMixin,
        ReadDtaSourceMixin,
        UpdateDataSourceMixin,
        ListDataSourceMixin,
        DeleteDataSourceMixin {}

mixin CreateDataSourceMixin {
  Future<Map<String, dynamic>> mixinCreate({
    required HttpClient http,
    required HttpRequest request,
    HttpMethod method = HttpMethod.POST,
    List<String> defaultJsonKeys = const ['result'],
  }) async {
    final response = await http.request<Map<String, dynamic>>(
      request,
      method: method,
      useDefaultBaseUrl: true,
      useDefaultInterceptors: true,
    );

    Map<String, dynamic> json = response.data!;

    if (defaultJsonKeys.length > 1) {
      final subList = defaultJsonKeys.sublist(0, defaultJsonKeys.length - 1);
      for (final String jsonKey in subList) {
        json = json[jsonKey];
      }
    }

    final Map<String, dynamic> result = defaultJsonKeys.isEmpty
        ? json
        : json[defaultJsonKeys.last];

    if (request.data is Map<String, dynamic>) {
      for (final entry in (request.data as Map<String, dynamic>).entries) {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }
}

mixin ReadDtaSourceMixin {
  Future<Map<String, dynamic>> mixinRead({
    required HttpClient http,
    required HttpRequest request,
    HttpMethod method = HttpMethod.GET,
    List<String> defaultJsonKeys = const ['result'],
  }) async {
    final response = await http.request<Map<String, dynamic>>(
      request,
      method: method,
      useDefaultBaseUrl: true,
      useDefaultInterceptors: true,
    );

    Map<String, dynamic> json = response.data!;

    if (defaultJsonKeys.length > 1) {
      final subList = defaultJsonKeys.sublist(0, defaultJsonKeys.length - 1);
      for (final String jsonKey in subList) {
        json = json[jsonKey];
      }
    }

    final Map<String, dynamic> result = defaultJsonKeys.isEmpty
        ? json
        : json[defaultJsonKeys.last];

    return result;
  }
}

mixin UpdateDataSourceMixin {
  Future<Map<String, dynamic>> mixinUpdate({
    required HttpClient http,
    required HttpRequest request,
    HttpMethod method = HttpMethod.PUT,
    List<String> defaultJsonKeys = const ['result'],
  }) async {
    final response = await http.request<Map<String, dynamic>>(
      request,
      method: method,
      useDefaultBaseUrl: true,
      useDefaultInterceptors: true,
    );

    Map<String, dynamic> json = response.data!;

    if (defaultJsonKeys.length > 1) {
      final subList = defaultJsonKeys.sublist(0, defaultJsonKeys.length - 1);
      for (final String jsonKey in subList) {
        json = json[jsonKey];
      }
    }

    final Map<String, dynamic> result = defaultJsonKeys.isEmpty
        ? json
        : json[defaultJsonKeys.last];

    if (request.data is Map<String, dynamic>) {
      for (final entry in (request.data as Map<String, dynamic>).entries) {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }
}

mixin ListDataSourceMixin {
  Future<List<Map<String, dynamic>>> mixinList({
    required HttpClient http,
    required HttpRequest request,
    HttpMethod method = HttpMethod.GET,
    List<String> defaultJsonKeys = const ['results'],
  }) async {
    final response = await http.request<Map<String, dynamic>>(
      request,
      method: method,
      useDefaultBaseUrl: true,
      useDefaultInterceptors: true,
    );

    Map<String, dynamic> json = response.data!;

    if (defaultJsonKeys.length > 1) {
      final subList = defaultJsonKeys.sublist(0, defaultJsonKeys.length - 1);
      for (final String jsonKey in subList) {
        json = json[jsonKey];
      }
    }

    return List.from(json[defaultJsonKeys.last] ?? []).map((item) {
      return item as Map<String, dynamic>;
    }).toList();
  }
}

mixin DeleteDataSourceMixin {
  Future<void> mixinDelete({
    required HttpClient http,
    required HttpRequest request,
    HttpMethod method = HttpMethod.DELETE,
  }) async {
    await http.request<Map<String, dynamic>>(
      request,
      method: method,
      useDefaultBaseUrl: true,
      useDefaultInterceptors: true,
    );
  }
}
