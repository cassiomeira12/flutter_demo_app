import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class CacheInterceptor extends Interceptor {
  final List<String> _cacheEndpoints;
  final CacheStorageUseCase _cacheStorageUseCase;
  final SecurityEncryptUseCase _securityEncryptUseCase;
  final SecurityEnvironmentEntity _securityEnv;

  CacheInterceptor({
    required List<EndpointsEnum> cacheEndpoints,
    required CacheStorageUseCase cacheStorageUseCase,
    required SecurityEncryptUseCase securityEncryptUseCase,
    required SecurityEnvironmentEntity securityEnv,
  }) : _cacheEndpoints = cacheEndpoints.map((item) {
         return item.endpointWithoutParams;
       }).toList(),
       _cacheStorageUseCase = cacheStorageUseCase,
       _securityEncryptUseCase = securityEncryptUseCase,
       _securityEnv = securityEnv;

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final String endpoint = response.requestOptions.path;
    final String? foundEndpoint = _cacheEndpoints.firstWhereOrNull((value) {
      return endpoint.contains(value);
    });

    //if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300)
    if (foundEndpoint == null || response.data == null) {
      return super.onResponse(response, handler);
    }

    final int? statusCode = response.statusCode;
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      scheduleMicrotask(() async {
        try {
          final String hashEndpoint = await _hashRequest(
            response.requestOptions,
          );
          final String dataEncrypted = await _securityEncryptUseCase.encrypt(
            password: _securityEnv.encryptKey,
            data: jsonEncode(response.data),
          );
          await _cacheStorageUseCase.save(hashEndpoint, dataEncrypted);
        } catch (error, stackTrace) {
          Log.error(error, stackTrace);
        }
      });
    }

    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final networkErrors = [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      // DioExceptionType.badCertificate,
      // DioExceptionType.badResponse,
      DioExceptionType.cancel,
      DioExceptionType.connectionError,
      DioExceptionType.unknown,
    ];

    if (!networkErrors.contains(err.type)) {
      return super.onError(err, handler);
    }

    final String endpoint = err.requestOptions.path;
    final String? foundEndpoint = _cacheEndpoints.firstWhereOrNull((value) {
      return endpoint.contains(value);
    });

    if (foundEndpoint == null) {
      return super.onError(err, handler);
    }

    try {
      final hashEndpoint = await _hashRequest(err.requestOptions);
      final bodyEncrypted = await _cacheStorageUseCase.load(hashEndpoint);

      if (bodyEncrypted != null && bodyEncrypted.isNotEmpty) {
        final body = await _securityEncryptUseCase.decrypt(
          password: _securityEnv.encryptKey,
          data: bodyEncrypted,
        );

        final dynamic data = jsonDecode(body);

        Log.warning(
          'Using Cache Data \n'
          'path: $endpoint \n'
          'data: $data \n',
          throwsCrashlytics: false,
        );

        return handler.resolve(
          Response(
            data: data,
            statusCode: 200,
            requestOptions: err.requestOptions,
          ),
        );
      }
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }

    return super.onError(err, handler);
  }

  Future<String> _hashRequest(RequestOptions request) async {
    String requestEndpoint = request.path;
    final String? requestData = request.data?.toString();
    final requestQueryParameters = request.queryParameters;

    if (requestData != null) {
      final String hash = _encryptString(requestData);
      requestEndpoint += hash;
    }

    if (requestQueryParameters.isNotEmpty) {
      final String hash = _encryptString(requestQueryParameters.toString());
      requestEndpoint += hash;
    }

    return _encryptString(requestEndpoint);
  }

  String _encryptString(String value) {
    return md5.convert(utf8.encode(value)).toString();
  }
}
