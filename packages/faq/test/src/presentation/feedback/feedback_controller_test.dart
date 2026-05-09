import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:faq/src/domain/domain.dart';
import 'package:faq/src/presentation/feedback/feedback_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSendUserFeedbackUseCase extends Mock
    implements SendUserFeedbackUseCase {}

class FakeUserFeedbackEntity extends Fake implements UserFeedbackEntity {}

void main() {
  late MockSendUserFeedbackUseCase mockSendUserFeedbackUseCase;
  late FeedbackController feedbackController;

  setUpAll(() {
    registerFallbackValue(FakeUserFeedbackEntity());
  });

  setUp(() {
    mockSendUserFeedbackUseCase = MockSendUserFeedbackUseCase();
    feedbackController = FeedbackController(
      sendUserFeedbackUseCase: mockSendUserFeedbackUseCase,
    );
  });

  group('FeedbackController', () {
    group('sendFeedback', () {
      group('Sucesso', () {
        test(
          'deve enviar feedback com sucesso quando parametros estao validos',
          () async {
            // arrange
            const name = 'John Doe';
            const email = 'john@example.com';
            const feedback = 'This is a great app!';

            when(() => mockSendUserFeedbackUseCase.call(any())).thenAnswer(
              (_) async {},
            );

            // act
            await feedbackController.sendFeedback(
              name: name,
              email: email,
              feedback: feedback,
            );

            // assert
            verify(() => mockSendUserFeedbackUseCase.call(any())).called(1);
          },
        );

        test(
          'deve criar entidade UserFeedbackEntity com parametros corretos',
          () async {
            // arrange
            const name = 'Jane Doe';
            const email = 'jane@example.com';
            const feedback = 'Love the new features!';

            final capturedEntity = <UserFeedbackEntity>[];

            when(() => mockSendUserFeedbackUseCase.call(any())).thenAnswer(
              (invocation) async {
                capturedEntity.add(
                  invocation.positionalArguments[0] as UserFeedbackEntity,
                );
              },
            );

            // act
            await feedbackController.sendFeedback(
              name: name,
              email: email,
              feedback: feedback,
            );

            // assert
            expect(capturedEntity.length, 1);
            expect(capturedEntity.first.name, name);
            expect(capturedEntity.first.email, email);
            expect(capturedEntity.first.feedback, feedback);
          },
        );
      });

      group('Erro', () {
        test(
          'deve propagar excecao quando sendUserFeedbackUseCase falhar',
          () async {
            // arrange
            const name = 'John Doe';
            const email = 'john@example.com';
            const feedback = 'Test feedback';

            final exception = BaseException(
              message: 'feedback_send_error',
            );

            when(
              () => mockSendUserFeedbackUseCase.call(any()),
            ).thenThrow(exception);

            // act & assert
            expect(
              () => feedbackController.sendFeedback(
                name: name,
                email: email,
                feedback: feedback,
              ),
              throwsA(isA<BaseException>()),
            );

            verify(() => mockSendUserFeedbackUseCase.call(any())).called(1);
          },
        );

        test(
          'deve propagar excecao de rede quando falhar conexao',
          () async {
            // arrange
            const name = 'John Doe';
            const email = 'john@example.com';
            const feedback = 'Test feedback';

            final exception = BaseException(
              message: 'network_error',
            );

            when(
              () => mockSendUserFeedbackUseCase.call(any()),
            ).thenThrow(exception);

            // act & assert
            expect(
              () => feedbackController.sendFeedback(
                name: name,
                email: email,
                feedback: feedback,
              ),
              throwsA(
                predicate<BaseException>(
                  (e) => e.message == 'network_error',
                ),
              ),
            );
          },
        );

        test(
          'deve propagar excecao quando servidor retornar erro',
          () async {
            // arrange
            const name = 'John Doe';
            const email = 'john@example.com';
            const feedback = 'Test feedback';

            final exception = BaseException(
              message: 'server_error',
              complement: 'HTTP 500',
            );

            when(
              () => mockSendUserFeedbackUseCase.call(any()),
            ).thenThrow(exception);

            // act & assert
            expect(
              () => feedbackController.sendFeedback(
                name: name,
                email: email,
                feedback: feedback,
              ),
              throwsA(
                predicate<BaseException>(
                  (e) => e.message == 'server_error',
                ),
              ),
            );
          },
        );
      });
    });

    group('feedbackValidator', () {
      group('Sucesso', () {
        test(
          'deve retornar null quando feedback e valido',
          () {
            // arrange
            const feedback = 'This is a valid feedback message.';

            // act
            final result = feedbackController.feedbackValidator(feedback);

            // assert
            expect(result, isNull);
          },
        );

        test(
          'deve retornar null quando feedback tem espacos',
          () {
            // arrange
            const feedback = '   Valid feedback with spaces   ';

            // act
            final result = feedbackController.feedbackValidator(feedback);

            // assert
            expect(result, isNull);
          },
        );
      });

      group('Erro', () {
        test(
          'deve retornar mensagem de erro quando feedback vazio',
          () {
            // arrange
            const feedback = '';

            // act
            final result = feedbackController.feedbackValidator(feedback);

            // assert
            expect(result, 'feedback_input_empty_error'.tr);
          },
        );

        test(
          'deve retornar mensagem de erro quando feedback e nulo',
          () {
            // arrange
            const String? feedback = null;

            // act
            final result = feedbackController.feedbackValidator(feedback);

            // assert
            expect(result, 'feedback_input_empty_error'.tr);
          },
        );

        test(
          'deve retornar mensagem de erro quando feedback e apenas espacos',
          () {
            // arrange
            const feedback = '   ';

            // act
            final result = feedbackController.feedbackValidator(feedback);

            // assert
            expect(result, 'feedback_input_empty_error'.tr);
          },
        );
      });
    });
  });
}
