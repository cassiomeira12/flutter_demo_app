import '../../infra/infra.dart';

abstract class Http {
  Future<HttpResponse<T>> get<T>(HttpRequest request);

  Future<HttpResponse<T>> post<T>(HttpRequest request);

  Future<HttpResponse<T>> put<T>(HttpRequest request);

  Future<HttpResponse<T>> delete<T>(HttpRequest request);
}
