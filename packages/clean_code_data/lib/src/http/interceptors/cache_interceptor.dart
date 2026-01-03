import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class CacheInterceptor extends Interceptor {
  final List<String> _cacheEndpoints;
  final CacheStorageUseCase _cacheStorageUseCase;
  final SecurityEncryptUseCase _securityEncryptUseCase;

  CacheInterceptor({
    required List<EndpointsEnum> cacheEndpoints,
    required CacheStorageUseCase cacheStorageUseCase,
    required SecurityEncryptUseCase securityEncryptUseCase,
  }) : _cacheEndpoints = cacheEndpoints.map((item) {
         return item.endpointWithoutParams;
       }).toList(),
       _cacheStorageUseCase = cacheStorageUseCase,
       _securityEncryptUseCase = securityEncryptUseCase;

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final String endpoint = response.requestOptions.path;
    final String? foundEndpoint = _cacheEndpoints.firstWhereOrNull((value) {
      return endpoint.contains(value);
    });
    if (foundEndpoint != null) {
      final String hashEndpoint = await _hashRequest(response.requestOptions);

      const String encryptKey = String.fromEnvironment('encrypter_key');

      final String dataEncrypted = _securityEncryptUseCase.encrypt(
        password: encryptKey,
        data: jsonEncode(response.data),
      );

      await _cacheStorageUseCase.save(hashEndpoint, dataEncrypted);
    }

    super.onResponse(response, handler);
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

    if (networkErrors.contains(err.type)) {
      final String endpoint = err.requestOptions.path;
      final String? foundEndpoint = _cacheEndpoints.firstWhereOrNull((value) {
        return endpoint.contains(value);
      });
      if (foundEndpoint != null) {
        final String hashEndpoint = await _hashRequest(err.requestOptions);
        final String? bodyEncrypted = await _cacheStorageUseCase.load(
          hashEndpoint,
        );

        if (bodyEncrypted != null && bodyEncrypted.isNotEmpty) {
          const String encryptKey = String.fromEnvironment('encrypter_key');

          final String body = _securityEncryptUseCase.decrypt(
            password: encryptKey,
            data: bodyEncrypted,
          );

          final dynamic data = jsonDecode(body);

          handler.resolve(
            Response(
              data: data,
              statusCode: 200,
              requestOptions: err.requestOptions,
            ),
          );
          return;
        }
      }
    }

    super.onError(err, handler);
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
