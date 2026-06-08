import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:faq/src/domain/domain.dart';
import 'package:faq/src/presentation/feedback/feedback_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSendUserFeedbackUseCase extends Mock
    implements SendUserFeedbackUseCase {}

void main() {
  late MockSendUserFeedbackUseCase mockSendUserFeedbackUseCase;
  late FeedbackController feedbackController;

  setUpAll(() {
    registerFallbackValue(
      UserFeedbackEntity(
        name: 'nome',
        email: 'email@teste.com',
        feedback: 'feedback de teste',
      ),
    );
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
  });

  setUp(() {
    mockSendUserFeedbackUseCase = MockSendUserFeedbackUseCase();
    feedbackController = FeedbackController(
      sendUserFeedbackUseCase: mockSendUserFeedbackUseCase,
    );
  });

  group('FeedbackController', () {
    group('feedbackValidator', () {
      group('Sucesso', () {
        test(
          'deve retornar null quando o feedback e valido',
          () {
            // act
            final result = feedbackController.feedbackValidator(
              'feedback valido',
            );

            // assert
            expect(result, isNull);
          },
        );
      });

      group('Erro', () {
        test(
          'deve retornar mensagem de erro quando o input e null',
          () {
            // act
            final result = feedbackController.feedbackValidator(null);

            // assert
            expect(result, 'feedback_input_empty_error'.tr);
          },
        );

        test(
          'deve retornar mensagem de erro quando o input e vazio',
          () {
            // act
            final result = feedbackController.feedbackValidator('');

            // assert
            expect(result, 'feedback_input_empty_error'.tr);
          },
        );

        test(
          'deve retornar mensagem de erro quando o input tem apenas espacos',
          () {
            // act
            final result = feedbackController.feedbackValidator('   ');

            // assert
            expect(result, 'feedback_input_empty_error'.tr);
          },
        );
      });
    });

    group('sendFeedback', () {
      const name = 'Usuário Teste';
      const email = 'usuario@teste.com';
      const feedback = 'Este é um feedback de teste.';

      group('Sucesso', () {
        test(
          'deve enviar feedback com sucesso quando o use case retorna',
          () async {
            // arrange
            when(
              () => mockSendUserFeedbackUseCase.call(any()),
            ).thenAnswer((_) async {});

            // act
            await feedbackController.sendFeedback(
              name: name,
              email: email,
              feedback: feedback,
            );

            // assert
            verify(
              () => mockSendUserFeedbackUseCase.call(any()),
            ).called(1);
          },
        );
      });

      group('Erro', () {
        test(
          'deve lancar BaseException quando o use case lanca excecao',
          () async {
            // arrange
            when(
              () => mockSendUserFeedbackUseCase.call(any()),
            ).thenThrow(
              BaseException(message: 'erro ao enviar feedback'),
            );

            // act & assert
            expect(
              () => feedbackController.sendFeedback(
                name: name,
                email: email,
                feedback: feedback,
              ),
              throwsA(isA<BaseException>()),
            );

            verify(
              () => mockSendUserFeedbackUseCase.call(any()),
            ).called(1);
          },
        );
      });
    });
  });
}
