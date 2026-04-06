import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.info(
      'Request ${options.method} ${options.uri} \n'
      'headers: ${options.headers} \n'
      'queryParams: ${options.queryParameters} \n'
      'data: ${options.data}',
    );

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.success(
      'Response ${response.requestOptions.method} \n'
      'path: ${response.requestOptions.uri} \n'
      'status code: ${response.statusCode} \n'
      'body: $response',
      throwsCrashlytics: false,
    );

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    CrashlyticsServiceManager.instance.logHttp(
      'Response ERROR ${err.requestOptions.method} \n'
      'path: ${err.requestOptions.uri} \n'
      'status code: ${err.response?.statusCode} \n'
      'body: ${err.response} \n'
      'type: ${err.type}',
      level: CrashlyticsLogLevel.error,
    );

    return super.onError(err, handler);
  }
}
