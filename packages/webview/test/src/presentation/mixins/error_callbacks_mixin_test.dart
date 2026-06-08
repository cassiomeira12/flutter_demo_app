import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview/src/presentation/mixins/mixins.dart';
import 'package:webview/src/presentation/webview/widgets/webview_widget_controller.dart';

class MockWebResourceRequest extends Mock implements WebResourceRequest {}

class MockWebResourceError extends Mock implements WebResourceError {}

class MockWebResourceResponse extends Mock implements WebResourceResponse {}

class MockRenderProcessGoneDetail extends Mock
    implements RenderProcessGoneDetail {}

class MockWebViewWidgetController extends Mock
    implements WebViewWidgetController {}

class ErrorCallbacksTest with ErrorCallbacksMixin {}

void main() {
  setUpAll(() {
    registerFallbackValue(TrackOperationStatus.ok);
  });

  late MockWebResourceRequest mockRequest;
  late MockWebResourceError mockError;
  late MockWebResourceResponse mockResponse;
  late MockRenderProcessGoneDetail mockRenderProcessGoneDetail;
  late MockWebViewWidgetController mockController;
  late ErrorCallbacksTest subject;
  late List<String> logs;
  late List<Map<String, dynamic>> errors;
  late int processGoneCount;

  setUp(() {
    mockRequest = MockWebResourceRequest();
    mockError = MockWebResourceError();
    mockResponse = MockWebResourceResponse();
    mockRenderProcessGoneDetail = MockRenderProcessGoneDetail();
    mockController = MockWebViewWidgetController();
    subject = ErrorCallbacksTest();
    logs = [];
    errors = [];
    processGoneCount = 0;

    when(
      () => mockController.finishTrackPerformance(
        error: any(named: 'error'),
        status: any(named: 'status'),
      ),
    ).thenReturn(null);

    when(() => mockResponse.toJson()).thenReturn({});
  });

  // ========================================================================
  // Helpers
  // ========================================================================

  void onError({required bool isNetworkError, String? error}) {
    errors.add({'isNetworkError': isNetworkError, 'error': error});
  }

  void onLog(String log) => logs.add(log);

  void processGone() => processGoneCount++;

  // ========================================================================
  // onReceivedError
  // ========================================================================

  group('onReceivedError', () {
    group('Cenários de Retorno Antecipado (early return)', () {
      test(
        'deve retornar sem chamar onError quando request não é main frame',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(false);

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          expect(errors, isEmpty);
        },
      );

      test(
        'deve retornar sem chamar onError quando description contém code=102',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockError.description).thenReturn('code=102');
          when(() => mockError.type).thenReturn(WebResourceErrorType.UNKNOWN);

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          expect(errors, isEmpty);
        },
      );

      test(
        'deve retornar sem chamar onError quando request é cancelled (-999)',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockError.description).thenReturn(
            'net::ERR_FAILED -999',
          );
          when(() => mockError.type).thenReturn(
            WebResourceErrorType.CANCELLED,
          );

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          expect(errors, isEmpty);
        },
      );
    });

    group('Cenários de Erro de Rede (isNetworkError = true)', () {
      test(
        'deve identificar network error quando description contém ERR_INTERNET_DISCONNECTED',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockError.description).thenReturn(
            'net::ERR_INTERNET_DISCONNECTED',
          );
          when(() => mockError.type).thenReturn(
            WebResourceErrorType.UNKNOWN,
          );

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          expect(errors, isNotEmpty);
          expect(
            errors.first['isNetworkError'],
            isTrue,
            reason: 'deveria ser erro de rede',
          );
        },
      );

      test(
        'deve identificar network error quando type é NOT_CONNECTED_TO_INTERNET',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockError.description).thenReturn(
            'some random error',
          );
          when(() => mockError.type).thenReturn(
            WebResourceErrorType.NOT_CONNECTED_TO_INTERNET,
          );

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          expect(errors, isNotEmpty);
          expect(errors.first['isNetworkError'], isTrue);
        },
      );

      test(
        'deve identificar network error quando type é NETWORK_CONNECTION_LOST',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockError.description).thenReturn(
            'connection lost',
          );
          when(() => mockError.type).thenReturn(
            WebResourceErrorType.NETWORK_CONNECTION_LOST,
          );

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          expect(errors, isNotEmpty);
          expect(errors.first['isNetworkError'], isTrue);
        },
      );
    });

    group('Cenários de Erro Não-Rede (isNetworkError = false)', () {
      test(
        'deve identificar erro não-rede para description desconhecida',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockError.description).thenReturn(
            'net::ERR_FAILED_UNKNOWN',
          );
          when(() => mockError.type).thenReturn(
            WebResourceErrorType.UNKNOWN,
          );

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          expect(errors, isNotEmpty);
          expect(errors.first['isNetworkError'], isFalse);
        },
      );

      test(
        'deve identificar erro não-rede para type ERROR comum',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockError.description).thenReturn(
            'net::ERR_SSL_PROTOCOL_ERROR',
          );
          when(() => mockError.type).thenReturn(
            WebResourceErrorType.UNKNOWN,
          );

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          expect(errors, isNotEmpty);
          expect(errors.first['isNetworkError'], isFalse);
        },
      );
    });

    group('Cenários de Callbacks e Logs', () {
      test(
        'deve chamar onLog com a mensagem formatada corretamente',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockError.description).thenReturn(
            'net::ERR_NAME_NOT_RESOLVED',
          );
          when(() => mockError.type).thenReturn(
            WebResourceErrorType.UNKNOWN,
          );

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          expect(
            logs.any((l) => l.contains('onReceivedError')),
            isTrue,
          );
          expect(
            logs.any((l) => l.contains('net::ERR_NAME_NOT_RESOLVED')),
            isTrue,
          );
        },
      );

      test(
        'deve chamar finishTrackPerformance no controller',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockError.description).thenReturn(
            'net::ERR_TIMEOUT',
          );
          when(() => mockError.type).thenReturn(
            WebResourceErrorType.UNKNOWN,
          );

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          verify(
            () => mockController.finishTrackPerformance(
              error: any(named: 'error'),
              status: any(named: 'status'),
            ),
          ).called(1);
        },
      );

      test(
        'deve chamar onError com a mensagem formatada',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockError.description).thenReturn(
            'net::ERR_FAILED',
          );
          when(() => mockError.type).thenReturn(
            WebResourceErrorType.UNKNOWN,
          );

          subject.onReceivedError(
            mockRequest,
            mockError,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
          );

          expect(errors, isNotEmpty);
          expect(
            errors.first['error'],
            contains('net::ERR_FAILED'),
          );
        },
      );
    });
  });

  // ========================================================================
  // onReceivedHttpError
  // ========================================================================

  group('onReceivedHttpError', () {
    group('Cenários de Retorno Antecipado (early return)', () {
      test(
        'deve retornar sem chamar onError quando request não é main frame',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(false);

          subject.onReceivedHttpError(
            mockRequest,
            mockResponse,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
            processGone: processGone,
          );

          expect(errors, isEmpty);
          expect(logs, isEmpty);
        },
      );

      test(
        'deve logar e retornar quando statusCode é null',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockResponse.statusCode).thenReturn(null);
          when(() => mockResponse.toJson()).thenReturn({});

          subject.onReceivedHttpError(
            mockRequest,
            mockResponse,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
            processGone: processGone,
          );

          expect(errors, isEmpty);
          expect(
            logs.any((l) => l.contains('onReceivedHttpError')),
            isTrue,
          );
        },
      );

      test(
        'deve retornar sem chamar onError quando statusCode é -999',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockResponse.statusCode).thenReturn(-999);

          subject.onReceivedHttpError(
            mockRequest,
            mockResponse,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
            processGone: processGone,
          );

          expect(errors, isEmpty);
        },
      );

      test(
        'deve retornar sem chamar onError quando statusCode é 102',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockResponse.statusCode).thenReturn(102);

          subject.onReceivedHttpError(
            mockRequest,
            mockResponse,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
            processGone: processGone,
          );

          expect(errors, isEmpty);
        },
      );
    });

    group('Cenários de Erro Recuperável (recoverable error)', () {
      for (final statusCode in [408, 503, 504, 599]) {
        test(
          'deve chamar processGone para statusCode $statusCode',
          () {
            when(() => mockRequest.isForMainFrame).thenReturn(true);
            when(() => mockResponse.statusCode).thenReturn(statusCode);

            subject.onReceivedHttpError(
              mockRequest,
              mockResponse,
              webViewController: mockController,
              onError: onError,
              onLog: onLog,
              processGone: processGone,
            );

            expect(processGoneCount, 1);
            expect(errors, isEmpty);
          },
        );
      }
    });

    group('Cenários de Status Code Específicos', () {
      test(
        'deve chamar onError com isNetworkError false para statusCode 403',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockResponse.statusCode).thenReturn(403);

          subject.onReceivedHttpError(
            mockRequest,
            mockResponse,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
            processGone: processGone,
          );

          expect(errors, isNotEmpty);
          expect(errors.first['isNetworkError'], isFalse);
          expect(
            errors.first['error'],
            contains('Forbidden'),
          );
        },
      );

      test(
        'deve chamar onError com isNetworkError false para statusCode 404',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockResponse.statusCode).thenReturn(404);

          subject.onReceivedHttpError(
            mockRequest,
            mockResponse,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
            processGone: processGone,
          );

          expect(errors, isNotEmpty);
          expect(errors.first['isNetworkError'], isFalse);
          expect(
            errors.first['error'],
            contains('Página não encontrada'),
          );
        },
      );

      test(
        'deve chamar onError com isNetworkError false para statusCode 500',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockResponse.statusCode).thenReturn(500);

          subject.onReceivedHttpError(
            mockRequest,
            mockResponse,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
            processGone: processGone,
          );

          expect(errors, isNotEmpty);
          expect(errors.first['isNetworkError'], isFalse);
          expect(
            errors.first['error'],
            contains('Ocorreu um erro no servidor'),
          );
        },
      );
    });

    group('Cenário de Erro Genérico (outros status codes)', () {
      test(
        'deve chamar onError com isNetworkError true para statusCode 400',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockResponse.statusCode).thenReturn(400);

          subject.onReceivedHttpError(
            mockRequest,
            mockResponse,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
            processGone: processGone,
          );

          expect(errors, isNotEmpty);
          expect(errors.first['isNetworkError'], isTrue);
          expect(
            errors.first['error'],
            contains('statusCode: 400'),
          );
        },
      );
    });

    group('Cenários de Callbacks e Logs', () {
      test(
        'deve chamar onLog e finishTrackPerformance para erro HTTP',
        () {
          when(() => mockRequest.isForMainFrame).thenReturn(true);
          when(() => mockResponse.statusCode).thenReturn(500);
          when(() => mockResponse.toJson()).thenReturn(
            {'statusCode': 500},
          );

          subject.onReceivedHttpError(
            mockRequest,
            mockResponse,
            webViewController: mockController,
            onError: onError,
            onLog: onLog,
            processGone: processGone,
          );

          expect(
            logs.any((l) => l.contains('onReceivedHttpError')),
            isTrue,
          );
          verify(
            () => mockController.finishTrackPerformance(
              error: any(named: 'error'),
              status: any(named: 'status'),
            ),
          ).called(1);
        },
      );
    });
  });

  // ========================================================================
  // onRenderProcessGone
  // ========================================================================

  group('onRenderProcessGone', () {
    test(
      'deve chamar onLog, finishTrackPerformance e processGone',
      () {
        subject.onRenderProcessGone(
          mockRenderProcessGoneDetail,
          webViewController: mockController,
          onLog: onLog,
          processGone: processGone,
        );

        expect(
          logs.any((l) => l.contains('onRenderProcessGone')),
          isTrue,
        );
        expect(processGoneCount, 1);
        verify(
          () => mockController.finishTrackPerformance(
            error: any(named: 'error'),
            status: any(named: 'status'),
          ),
        ).called(1);
      },
    );
  });

  // ========================================================================
  // onWebContentProcessDidTerminate
  // ========================================================================

  group('onWebContentProcessDidTerminate', () {
    test(
      'deve chamar onLog, finishTrackPerformance e processGone',
      () {
        subject.onWebContentProcessDidTerminate(
          webViewController: mockController,
          onLog: onLog,
          processGone: processGone,
        );

        expect(
          logs.any((l) => l.contains('onWebContentProcessDidTerminate')),
          isTrue,
        );
        expect(processGoneCount, 1);
        verify(
          () => mockController.finishTrackPerformance(
            error: any(named: 'error'),
            status: any(named: 'status'),
          ),
        ).called(1);
      },
    );
  });
}
