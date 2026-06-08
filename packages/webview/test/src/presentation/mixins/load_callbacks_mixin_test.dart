import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview/src/domain/enums/load_webview_step_enum.dart';
import 'package:webview/src/presentation/mixins/mixins.dart';
import 'package:webview/src/presentation/webview/widgets/webview_widget_controller.dart';

class MockWebViewWidgetController extends Mock
    implements WebViewWidgetController {}

class MockTrackOperation extends Mock implements TrackOperation {}

class LoadCallbacksTest with LoadCallbacksMixin {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://fallback.example.com'));
    registerFallbackValue(TrackOperationStatus.ok);
  });

  late MockWebViewWidgetController mockController;
  late LoadCallbacksTest subject;
  late List<String> logs;
  late bool isLoading;

  setUp(() {
    mockController = MockWebViewWidgetController();
    subject = LoadCallbacksTest();
    logs = <String>[];
    isLoading = false;

    when(() => mockController.lastProgress).thenReturn(ValueNotifier<int>(0));
    when(() => mockController.startOnCreatedWebViewTrack()).thenReturn(null);
    when(() => mockController.trackPerformance).thenReturn(null);
    when(
      () => mockController.currentStep,
    ).thenReturn(LoadWebviewStepEnum.webViewCreated);
    when(() => mockController.nextStep()).thenReturn(null);
    when(() => mockController.startLoadingTimer()).thenAnswer((_) async {});
    when(() => mockController.setProgress(any())).thenReturn(null);
    when(() => mockController.clearLoadingManager()).thenReturn(null);
    when(() => mockController.startTrackPerformance(any())).thenReturn(null);
    when(() => mockController.startOnStartLoadingTrack()).thenReturn(null);
    when(() => mockController.setCurrentUri(any())).thenReturn(null);
    when(
      () => mockController.finishTrackPerformance(
        error: any(named: 'error'),
        status: any(named: 'status'),
      ),
    ).thenReturn(null);
    when(() => mockController.finishFullLoadingTracking()).thenReturn(null);
    when(
      () => mockController.updateSystemThemeData(any()),
    ).thenAnswer((_) async {});
  });

  group('onWebViewCreated', () {
    group('Sucesso', () {
      test(
        'deve executar todas as chamadas corretamente quando url é fornecida',
        () {
          final trackOp = MockTrackOperation();
          when(
            () => mockController.startOnCreatedWebViewTrack(),
          ).thenReturn(trackOp);

          subject.onWebViewCreated(
            'https://example.com',
            webViewController: mockController,
            loading: (bool v) => isLoading = v,
            onLog: (String log) => logs.add(log),
          );

          verify(() => mockController.startOnCreatedWebViewTrack()).called(1);
          expect(
            logs.any((String l) => l.contains('onWebViewCreated')),
            isTrue,
          );
          expect(isLoading, true);
          verify(() => mockController.nextStep()).called(1);
          verify(() => mockController.startLoadingTimer()).called(1);
          expect(logs.any((String l) => l.contains('onWebViewCreated')), isTrue);
        },
      );

      test(
        'deve executar corretamente quando url é null',
        () {
          subject.onWebViewCreated(
            null,
            webViewController: mockController,
            loading: (bool v) => isLoading = v,
            onLog: (String log) => logs.add(log),
          );

          verify(() => mockController.startOnCreatedWebViewTrack()).called(1);
          expect(logs.any((String l) => l.contains('null')), isTrue);
          expect(isLoading, true);
          verify(() => mockController.nextStep()).called(1);
        },
      );

      test(
        'deve armazenar o track retornado em onCreatedTrack',
        () {
          final trackOp = MockTrackOperation();
          when(
            () => mockController.startOnCreatedWebViewTrack(),
          ).thenReturn(trackOp);

          subject.onWebViewCreated(
            'https://example.com',
            webViewController: mockController,
            loading: (bool v) => isLoading = v,
            onLog: (String log) => logs.add(log),
          );

          expect(subject.onCreatedTrack, trackOp);
        },
      );
    });

    group('Erro', () {
      test(
        'deve propagar exceção quando startOnCreatedWebViewTrack lança erro',
        () {
          when(
            () => mockController.startOnCreatedWebViewTrack(),
          ).thenThrow(Exception('Erro track'));

          expect(
            () => subject.onWebViewCreated(
              'https://example.com',
              webViewController: mockController,
              loading: (bool v) => isLoading = v,
              onLog: (String log) => logs.add(log),
            ),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });

  group('onLoadStart', () {
    group('Sucesso', () {
      test(
        'deve executar todas as chamadas quando step é onLoadStarted '
        'e webUri é válido',
        () {
          final trackOp = MockTrackOperation();
          final childTrack = MockTrackOperation();
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.loadStarted);
          when(() => mockController.trackPerformance).thenReturn(trackOp);
          when(
            () => trackOp.startChild(name: any(named: 'name')),
          ).thenReturn(childTrack);
          subject.onCreatedTrack = trackOp;

          subject.onLoadStart(
            WebUri('https://example.com'),
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
          );

          verify(() => mockController.clearLoadingManager()).called(1);
          verify(() => trackOp.finish()).called(1);
          verify(() => mockController.startTrackPerformance(any())).called(1);
          verify(() => mockController.startOnStartLoadingTrack()).called(1);
          verify(
            () => trackOp.startChild(name: any(named: 'name')),
          ).called(1);
          expect(subject.onPageCommitTrack, childTrack);
        },
      );

      test(
        'deve executar corretamente com webUri null',
        () {
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.loadStarted);

          subject.onLoadStart(
            null,
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
          );

          verify(() => mockController.clearLoadingManager()).called(1);
          verify(() => mockController.startTrackPerformance(null)).called(1);
          verify(() => mockController.setCurrentUri(null)).called(1);
        },
      );
    });

    group('Erro e Casos de Borda', () {
      test(
        'deve retornar cedo quando step não é onLoadStarted',
        () {
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.webViewCreated);

          subject.onLoadStart(
            WebUri('https://example.com'),
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
          );

          verify(() => mockController.clearLoadingManager()).called(1);
          verifyNever(() => mockController.startTrackPerformance(any()));
          verifyNever(() => mockController.nextStep());
        },
      );

      test(
        'deve continuar sem child track quando trackPerformance é null',
        () {
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.loadStarted);
          when(() => mockController.trackPerformance).thenReturn(null);
          subject.onCreatedTrack = null;

          subject.onLoadStart(
            WebUri('https://example.com'),
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
          );

          expect(subject.onPageCommitTrack, isNull);
          verify(() => mockController.nextStep()).called(1);
        },
      );

      test(
        'deve continuar quando onCreatedTrack é null (finish não é chamado)',
        () {
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.loadStarted);
          subject.onCreatedTrack = null;

          subject.onLoadStart(
            WebUri('https://example.com'),
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
          );

          verify(() => mockController.nextStep()).called(1);
        },
      );
    });
  });

  group('onProgressChanged', () {
    group('Sucesso', () {
      test(
        'deve atualizar progresso e avançar step quando progress > lastProgress '
        'e step é progressChanged',
        () {
          final lastProgress = ValueNotifier<int>(0);
          when(() => mockController.lastProgress).thenReturn(lastProgress);
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.progressChanged);

          subject.onProgressChanged(
            50,
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
          );

          expect(logs.any((String l) => l.contains('50%')), isTrue);
          verify(() => mockController.setProgress(50)).called(1);
          verify(() => mockController.startLoadingTimer()).called(1);
          verify(() => mockController.nextStep()).called(1);
        },
      );

      test(
        'deve atualizar progresso sem avançar step quando step é pageVisible',
        () {
          final lastProgress = ValueNotifier<int>(0);
          when(() => mockController.lastProgress).thenReturn(lastProgress);
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.pageVisible);

          subject.onProgressChanged(
            50,
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
          );

          expect(logs.any((String l) => l.contains('50%')), isTrue);
          verify(() => mockController.setProgress(50)).called(1);
          verify(() => mockController.startLoadingTimer()).called(1);
          verifyNever(() => mockController.nextStep());
        },
      );
    });

    group('Erro e Casos de Borda', () {
      test(
        'deve retornar cedo quando step não é greaterThanProgressStep',
        () {
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.loadStarted);

          subject.onProgressChanged(
            50,
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
          );

          verifyNever(() => mockController.setProgress(any()));
          verifyNever(() => mockController.nextStep());
        },
      );

      test(
        'não deve fazer nada quando progress é igual ao lastProgress',
        () {
          final lastProgress = ValueNotifier<int>(50);
          when(() => mockController.lastProgress).thenReturn(lastProgress);
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.progressChanged);

          subject.onProgressChanged(
            50,
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
          );

          verifyNever(() => mockController.setProgress(any()));
          verifyNever(() => mockController.nextStep());
        },
      );

      test(
        'não deve fazer nada quando progress é menor que lastProgress',
        () {
          final lastProgress = ValueNotifier<int>(80);
          when(() => mockController.lastProgress).thenReturn(lastProgress);
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.progressChanged);

          subject.onProgressChanged(
            50,
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
          );

          verifyNever(() => mockController.setProgress(any()));
          verifyNever(() => mockController.nextStep());
        },
      );
    });
  });

  group('onPageCommitVisible', () {
    group('Sucesso', () {
      test(
        'deve executar todas as chamadas quando webUri é válido',
        () {
          final trackOp = MockTrackOperation();
          subject.onPageCommitTrack = trackOp;

          subject.onPageCommitVisible(
            WebUri('https://example.com'),
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
            processGone: () {},
          );

          verify(() => trackOp.finish()).called(1);
          expect(
            logs.any((String l) => l.contains('onPageCommitVisible')),
            isTrue,
          );
          verify(() => mockController.nextStep()).called(1);
          verify(() => mockController.setCurrentUri(any())).called(1);
          verify(() => mockController.startLoadingTimer()).called(1);
        },
      );

      test(
        'deve finalizar onPageCommitTrack mesmo quando onPageCommitTrack é null',
        () {
          subject.onPageCommitTrack = null;

          subject.onPageCommitVisible(
            WebUri('https://example.com'),
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
            processGone: () {},
          );

          verify(() => mockController.nextStep()).called(1);
          verify(() => mockController.startLoadingTimer()).called(1);
        },
      );
    });

    group('Erro', () {
      test(
        'deve chamar processGone e finishTrackPerformance quando webUri é null',
        () {
          var processGoneCalled = false;

          subject.onPageCommitVisible(
            null,
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
            processGone: () => processGoneCalled = true,
          );

          expect(processGoneCalled, true);
          verify(
            () => mockController.finishTrackPerformance(
              error: any(named: 'error'),
              status: any(named: 'status'),
            ),
          ).called(1);
          expect(
            logs.any((String l) => l.contains('about:blank')),
            isTrue,
          );
          verifyNever(() => mockController.nextStep());
        },
      );

      test(
        'deve chamar processGone e finishTrackPerformance quando webUri '
        'contém about:blank',
        () {
          var processGoneCalled = false;

          subject.onPageCommitVisible(
            WebUri('about:blank'),
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
            processGone: () => processGoneCalled = true,
          );

          expect(processGoneCalled, true);
          verify(
            () => mockController.finishTrackPerformance(
              error: any(named: 'error'),
              status: any(named: 'status'),
            ),
          ).called(1);
          expect(
            logs.any((String l) => l.contains('about:blank')),
            isTrue,
          );
          verifyNever(() => mockController.nextStep());
        },
      );
    });
  });

  group('onLoadStop', () {
    group('Sucesso', () {
      test(
        'deve executar todas as chamadas quando webUri é válido '
        'e step é válido',
        () {
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.pageVisible);

          subject.onLoadStop(
            WebUri('https://example.com'),
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
            processGone: () {},
          );

          expect(
            logs.any((String l) => l.contains('onLoadStop')),
            isTrue,
          );
          verify(() => mockController.nextStep()).called(1);
          verify(() => mockController.setCurrentUri(any())).called(1);
          verify(() => mockController.finishFullLoadingTracking()).called(1);
        },
      );
    });

    group('Erro e Casos de Borda', () {
      test(
        'deve retornar cedo quando step não é greaterThanProgressStep',
        () {
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.loadStarted);

          subject.onLoadStop(
            WebUri('https://example.com'),
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
            processGone: () {},
          );

          verifyNever(() => mockController.nextStep());
          verifyNever(() => mockController.finishFullLoadingTracking());
        },
      );

      test(
        'deve chamar processGone e finishTrackPerformance quando webUri é null',
        () {
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.pageVisible);
          var processGoneCalled = false;

          subject.onLoadStop(
            null,
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
            processGone: () => processGoneCalled = true,
          );

          expect(processGoneCalled, true);
          verify(
            () => mockController.finishTrackPerformance(
              error: any(named: 'error'),
              status: any(named: 'status'),
            ),
          ).called(1);
          expect(
            logs.any((String l) => l.contains('about:blank')),
            isTrue,
          );
          verifyNever(() => mockController.nextStep());
        },
      );

      test(
        'deve chamar processGone e finishTrackPerformance quando webUri '
        'contém about:blank',
        () {
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.pageVisible);
          var processGoneCalled = false;

          subject.onLoadStop(
            WebUri('about:blank'),
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
            processGone: () => processGoneCalled = true,
          );

          expect(processGoneCalled, true);
          verify(
            () => mockController.finishTrackPerformance(
              error: any(named: 'error'),
              status: any(named: 'status'),
            ),
          ).called(1);
          expect(
            logs.any((String l) => l.contains('about:blank')),
            isTrue,
          );
          verifyNever(() => mockController.nextStep());
        },
      );

      test(
        'não deve chamar finishFullLoadingTracking quando processGone é ativado',
        () {
          when(
            () => mockController.currentStep,
          ).thenReturn(LoadWebviewStepEnum.pageVisible);

          subject.onLoadStop(
            null,
            webViewController: mockController,
            onLog: (String log) => logs.add(log),
            processGone: () {},
          );

          verifyNever(() => mockController.finishFullLoadingTracking());
          verifyNever(() => mockController.nextStep());
        },
      );
    });
  });
}
