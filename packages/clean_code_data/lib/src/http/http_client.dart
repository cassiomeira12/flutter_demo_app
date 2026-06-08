import 'package:clean_code_data/clean_code_data.dart';

abstract class HttpClient {
  void addInterceptor(dynamic interceptor);

  void addAllInterceptors(List<dynamic> interceptors);

  Future<HttpResponse<T>> get<T>(HttpRequest request);

  Future<HttpResponse<T>> post<T>(HttpRequest request);

  Future<HttpResponse<T>> put<T>(HttpRequest request);

  Future<HttpResponse<T>> delete<T>(HttpRequest request);

  Future<HttpResponse<T>> request<T>(
    HttpRequest request, {
    required HttpMethod method,
    bool useDefaultBaseUrl = false,
    bool useDefaultInterceptors = false,
    bool useRefreshTokenInterceptor = true,
  });
}
