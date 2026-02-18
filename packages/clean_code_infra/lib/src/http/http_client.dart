import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_infra/src/http/interceptors/interceptors.dart';
import 'package:dependency/dependency.dart';

class HttpClientImpl implements HttpClient {
  final String _baseUrl;

  late Dio _dio;

  final defaultConnectTimeout = const Duration(seconds: 30);
  final defaultReceiveTimeout = const Duration(seconds: 30);
  final defaultSendTimeout = const Duration(seconds: 30);

  HttpClientImpl({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    List<Interceptor>? interceptors,
  }) : _baseUrl = baseUrl {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: connectTimeout ?? defaultConnectTimeout,
        receiveTimeout: receiveTimeout ?? defaultReceiveTimeout,
        sendTimeout: sendTimeout ?? defaultSendTimeout,
      ),
    );

    _dio.interceptors.addAll(interceptors ?? []);
    _dio.interceptors.add(LogInterceptor());

    _dio.addSentry();
  }

  @override
  void addInterceptor(dynamic interceptor) {
    if (interceptor is Interceptor) {
      final int index = _dio.interceptors.isEmpty
          ? 0
          : _dio.interceptors.length - 1;
      _dio.interceptors.insert(index, interceptor);
    }
  }

  @override
  void addAllInterceptors(List<dynamic> interceptors) {
    for (final interceptor in interceptors) {
      addInterceptor(interceptor);
    }
  }

  @override
  Future<HttpResponse<T>> get<T>(HttpRequest request) async {
    try {
      _dio.options.headers.addAll(request.headers);

      final Response<T> response = await _dio.get(
        request.url,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(
          sendTimeout: request.timeout,
          receiveTimeout: request.timeout,
        ),
      );

      return _mapperResponse(response);
    } on DioException catch (error) {
      throw _mapperDioError(error);
    }
  }

  @override
  Future<HttpResponse<T>> post<T>(
    HttpRequest request, {
    Duration? timeout,
  }) async {
    try {
      _dio.options.headers.addAll(request.headers);

      final Response<T> response = await _dio.post(
        request.url,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(
          sendTimeout: request.timeout,
          receiveTimeout: request.timeout,
        ),
      );

      return _mapperResponse(response);
    } on DioException catch (error) {
      throw _mapperDioError(error);
    }
  }

  @override
  Future<HttpResponse<T>> put<T>(
    HttpRequest request, {
    Duration? timeout,
  }) async {
    try {
      _dio.options.headers.addAll(request.headers);

      final Response<T> response = await _dio.put(
        request.url,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(
          sendTimeout: request.timeout,
          receiveTimeout: request.timeout,
        ),
      );

      return _mapperResponse(response);
    } on DioException catch (error) {
      throw _mapperDioError(error);
    }
  }

  @override
  Future<HttpResponse<T>> delete<T>(
    HttpRequest request, {
    Duration? timeout,
  }) async {
    try {
      _dio.options.headers.addAll(request.headers);

      final Response<T> response = await _dio.delete(
        request.url,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(
          sendTimeout: request.timeout,
          receiveTimeout: request.timeout,
        ),
      );

      return _mapperResponse(response);
    } on DioException catch (error) {
      throw _mapperDioError(error);
    }
  }

  @override
  Future<HttpResponse<T>> request<T>(
    HttpRequest request, {
    required HttpMethod method,
    bool useDefaultBaseUrl = false,
    bool useDefaultInterceptors = false,
    bool useRefreshTokenInterceptor = true,
  }) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: useDefaultBaseUrl ? _baseUrl : '',
        connectTimeout: request.timeout ?? defaultConnectTimeout,
        receiveTimeout: request.timeout ?? defaultReceiveTimeout,
      ),
    );

    for (final interceptor in _dio.interceptors) {
      if (interceptor is RefreshTokenInterceptor) {
        if (!useDefaultInterceptors) {
          continue;
        }
      }
      if (interceptor is ServerOtpInterceptor) {
        if (!useDefaultInterceptors) {
          continue;
        }
      }
      dio.interceptors.add(interceptor);
    }

    dio.addSentry();

    try {
      dio.options.headers.addAll(request.headers);

      final Response<T> response = await dio.request(
        request.url,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(
          method: method.name,
          sendTimeout: request.timeout,
          receiveTimeout: request.timeout,
        ),
      );

      return _mapperResponse(response);
    } on DioException catch (error) {
      throw _mapperDioError(error);
    } finally {
      dio.close();
    }
  }

  HttpException _mapperDioError(DioException error) {
    int? statusCode;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
        statusCode = 503;
      case DioExceptionType.receiveTimeout:
        statusCode = 504;
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
        statusCode = 400;
      case DioExceptionType.cancel:
      case DioExceptionType.connectionError:
        statusCode = 502;
      case DioExceptionType.unknown:
    }
    return HttpException(
      statusCode: error.response?.statusCode ?? statusCode ?? -1,
      statusMessage: error.response?.statusMessage,
      message: error.message ?? error.error.toString(),
      data: error.response?.data,
    );
  }

  HttpResponse<T> _mapperResponse<T>(Response<T>? response) {
    if (response == null) {
      throw HttpException();
      // throw HttpException(
      //   response: HttpResponse(statusCode: 500),
      // );
    }

    if (response.statusCode == 200 && response.data != null) {
      if (response.data is Map<String, dynamic>) {
        final data = response.data! as Map<String, dynamic>;
        if (data['error'] != null) {
          throw HttpException(
            statusCode: 400,
            message: data['error'],
            statusMessage: data['error'],
            data: data,
          );
        }
        if (data['errors'] != null) {
          final String error = List<Map<String, dynamic>>.from(
            data['errors'],
          ).first['message'];
          throw HttpException(
            statusCode: 400,
            message: error,
            statusMessage: error,
            data: data,
          );
        }
      }
    }

    return HttpResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      headers: response.headers.map,
    );
  }
}
