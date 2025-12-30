import 'package:dependency/dependency.dart';

mixin ErrorCallbacksExtension {
  void onReceivedError(
    WebResourceRequest request,
    WebResourceError error, {
    required void Function({required bool isNetworkError, String? error})
    onError,
    required void Function(String log) onLog,
  }) {
    if (request.isForMainFrame == false) {
      return;
    }

    final bool code102 = error.description.contains('code=102');
    final bool requestCancelled =
        error.description.contains('-999') &&
        error.type == WebResourceErrorType.CANCELLED;

    if (code102 || requestCancelled) {
      return;
    }

    final List<String> networkConnectionErros = [
      'net::ERR_INTERNET_DISCONNECTED',
      'net::ERR_NAME_NOT_RESOLVED',
      'net::ERR_CONNECTION_CLOSED',
      'net::ERR_CONNECTION_ABORTED',
      'net::ERR_TIME_OUT',
      'net::ERR_CONNECTION_REFUSED',
      'net::ERR_ADDRESS_UNREACHABLE',
      'net::ERR_DNS_NO_MATCHING_SUPPORTED_ALPN',
      'net::ERR_HTTP2_PING_FAILED',
    ];

    final List<WebResourceErrorType> networkConnectionErrosTypes = [
      WebResourceErrorType.NETWORK_CONNECTION_LOST,
      WebResourceErrorType.NOT_CONNECTED_TO_INTERNET,
      WebResourceErrorType.CANNOT_LOAD_FROM_NETWORK,
      WebResourceErrorType.REDIRECT_TO_NON_EXISTENT_LOCATION,
      WebResourceErrorType.DATA_NOT_ALLOWED,
      WebResourceErrorType.SERVER_CERTIFICATE_NOT_YET_VALID,
      WebResourceErrorType.NOT_CONNECTED_TO_INTERNET,
      WebResourceErrorType.TIMEOUT,
      WebResourceErrorType.HOST_LOOKUP,
      WebResourceErrorType.CANNOT_CONNECT_TO_HOST,
    ];

    final bool isNetworkError =
        networkConnectionErros.contains(error.description) ||
        networkConnectionErrosTypes.contains(error.type);

    onLog(
      'onReceivedError isNetworkError: $isNetworkError ${error.type} ${error.description}',
    );

    onError(
      isNetworkError: isNetworkError,
      error:
          'onReceivedError\nisNetworkError: $isNetworkError\n${error.type}\n${error.description}',
    );
  }

  void onReceivedHttpError(
    WebResourceRequest request,
    WebResourceResponse errorResponse, {
    required void Function({required bool isNetworkError, String? error})
    onError,
    required void Function(String log) onLog,
    required void Function() processGone,
  }) {
    if (request.isForMainFrame == false) {
      return;
    }

    if (errorResponse.statusCode == null) {
      onLog('ERROR onReceivedHttpError ${errorResponse.toJson()}');
      return;
    }

    final List<int> skipErros = [-999, 102];
    if (skipErros.contains(errorResponse.statusCode)) {
      return;
    }

    final int statusCode = errorResponse.statusCode!;

    // final isClientError = statusCode >= 400 && statusCode < 500;
    final isServerError = statusCode >= 500;
    final isRecoverableError = [408, 503, 504, 599].contains(statusCode);

    onLog('ERROR onReceivedHttpError ${errorResponse.toJson()}');

    if (isRecoverableError) {
      processGone();
      return;
    }

    if (statusCode == 403) {
      onError(isNetworkError: false, error: 'onReceivedError Forbidden');
      return;
    }

    if (statusCode == 404) {
      onError(
        isNetworkError: false,
        error: 'onReceivedError Página não encontrada',
      );
      return;
    }

    if (isServerError) {
      onError(
        isNetworkError: false,
        error: 'onReceivedError Ocorreu um erro no servidor',
      );
      return;
    }

    onError(
      isNetworkError: true,
      error: 'onReceivedHttpError statusCode: ${errorResponse.statusCode}}',
    );
  }

  void onRenderProcessGone(
    RenderProcessGoneDetail detail, {
    required void Function(String log) onLog,
    required void Function() processGone,
  }) {
    onLog('ERROR onRenderProcessGone $detail');
    processGone();
  }

  void onWebContentProcessDidTerminate({
    required void Function(String log) onLog,
    required void Function() processGone,
  }) {
    onLog('ERROR onWebContentProcessDidTerminate');
    processGone();
  }
}
