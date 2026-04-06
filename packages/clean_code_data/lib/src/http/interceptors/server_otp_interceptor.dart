import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ServerOtpInterceptor extends Interceptor {
  final GetOtpCodeUseCase _getOtpCodeUseCase;
  final EncryptServerPublicKeyUseCase _encryptServerUseCase;

  ServerOtpInterceptor({
    required GetOtpCodeUseCase getOtpCodeUseCase,
    required EncryptServerPublicKeyUseCase encryptServerPublicKeyUseCase,
  }) : _getOtpCodeUseCase = getOtpCodeUseCase,
       _encryptServerUseCase = encryptServerPublicKeyUseCase;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? encryptedCode = await _generateEncryptedHashTokenCode();

    if (encryptedCode != null) {
      options.headers.addAll({'Hash-Token-Code': encryptedCode});
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final invalidHashCode = err.response?.data?.toString().contains(
      'invalid_hash_token_code',
    );

    if (statusCode == 400 && invalidHashCode == true) {
      Log.warning(
        'Response ERROR ${err.requestOptions.method} \n'
        'path: ${err.requestOptions.uri} \n'
        'status code: ${err.response?.statusCode} \n'
        'body: ${err.response} \n'
        'type: ${err.type}',
        throwsCrashlytics: false,
      );
      await Future.delayed(const Duration(seconds: 1));
      try {
        Log.debug('Refreshing token...');
        final response = await _getRetryRequest(err);
        return handler.resolve(response);
      } catch (_) {
        super.onError(err, handler);
      }
    }

    super.onError(err, handler);
  }

  Future<String?> _generateEncryptedHashTokenCode() async {
    try {
      const String secretOTP = String.fromEnvironment('server_secret_otp');
      final String code = _getOtpCodeUseCase.call(secret: secretOTP);
      final String encryptedCode = await _encryptServerUseCase.call(code);

      if (code == encryptedCode) {
        throw BaseException(message: 'Hash-Token-Code is equals encryptedCode');
      }

      return encryptedCode;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return null;
    }
  }

  Future<Response> _getRetryRequest(DioException err) async {
    final http = AppBinding.find<HttpClient>();

    final String baseUrl = err.requestOptions.baseUrl;
    final String endpoint = err.requestOptions.path;

    final Map<String, dynamic> headers = {
      ...err.requestOptions.headers,
    };

    final String? encryptedCode = await _generateEncryptedHashTokenCode();

    if (encryptedCode != null) {
      headers['Hash-Token-Code'] = encryptedCode;
    }

    final request = HttpRequest(
      url: '$baseUrl$endpoint',
      data: err.requestOptions.data,
      queryParameters: err.requestOptions.queryParameters,
      headers: headers,
    );

    final httpMethod = HttpMethod.fromString(err.requestOptions.method);

    final response = await http.request(
      request,
      method: httpMethod,
    );

    return Response(
      requestOptions: err.requestOptions,
      data: response.data,
      statusCode: response.statusCode,
    );
  }
}
