import 'package:dio/dio.dart';

import '../../data/data.dart';
import '../../domain/domain.dart';
import 'exceptions/http_exceptions.dart';
import 'http_request.dart';
import 'http_response.dart';

class HttpClient implements Http {
  final EnvironmentEntity _environment;

  late Dio _dio;

  HttpClient({
    required EnvironmentEntity environment,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    List<Interceptor>? interceptors,
  }) : _environment = environment {
    _dio = Dio(
      BaseOptions(
        baseUrl: _environment.baseUrl,
        connectTimeout: connectTimeout ?? const Duration(seconds: 60),
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 60),
      ),
    );
    // _dio.interceptors.add(
    //   LogInterceptor(
    //     request: false,
    //     requestHeader: false,
    //     responseHeader: false,
    //     requestBody: true,
    //     responseBody: true,
    //   ),
    // );
    _dio.interceptors.addAll(interceptors ?? []);
  }

  @override
  Future<HttpResponse<T>> get<T>(HttpRequest request) async {
    try {
      _dio.options.headers.addAll(request.headers);

      final Response<T> response = await _dio.get(
        request.url,
        data: request.data,
        queryParameters: request.queryParameters,
      );

      return _mapperResponse(response);
    } on DioException catch (error) {
      throw _mapperError(error);
    }
  }

  @override
  Future<HttpResponse<T>> post<T>(HttpRequest request) async {
    try {
      _dio.options.headers.addAll(request.headers);

      final Response<T> response = await _dio.post(
        request.url,
        data: request.data,
        queryParameters: request.queryParameters,
      );

      return _mapperResponse(response);
    } on DioException catch (error) {
      throw _mapperError(error);
    }
  }

  @override
  Future<HttpResponse<T>> put<T>(HttpRequest request) async {
    try {
      _dio.options.headers.addAll(request.headers);

      final Response<T> response = await _dio.put(
        request.url,
        data: request.data,
        queryParameters: request.queryParameters,
      );

      return _mapperResponse(response);
    } on DioException catch (error) {
      throw _mapperError(error);
    }
  }

  @override
  Future<HttpResponse<T>> delete<T>(HttpRequest request) async {
    try {
      _dio.options.headers.addAll(request.headers);

      final Response<T> response = await _dio.delete(
        request.url,
        data: request.data,
        queryParameters: request.queryParameters,
      );

      return _mapperResponse(response);
    } on DioException catch (error) {
      throw _mapperError(error);
    }
  }

  HttpException _mapperError(DioException error) {
    return HttpException(
      type: error.type.name,
      error: error.error,
      message: error.message,
    );
  }

  HttpResponse<T> _mapperResponse<T>(Response<T>? response) {
    if (response == null) {
      throw HttpException(
        type: '',
      );
      // throw HttpException(
      //   response: HttpResponse(statusCode: 500),
      // );
    }

    return HttpResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      headers: response.headers.map,
    );
  }
}
