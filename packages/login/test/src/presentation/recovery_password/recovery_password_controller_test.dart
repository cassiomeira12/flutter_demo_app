import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/src/domain/domain.dart';
import 'package:login/src/presentation/recovery_password/recovery_password_controller.dart';

class MockRecoveryPasswordUseCase extends Mock
    implements RecoveryPasswordUseCase {}

void main() {
  late MockRecoveryPasswordUseCase mockRecoveryPasswordUseCase;
  late RecoveryPasswordController recoveryPasswordController;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
  });

  setUp(() {
    mockRecoveryPasswordUseCase = MockRecoveryPasswordUseCase();

    recoveryPasswordController = RecoveryPasswordController(
      recoveryPasswordUseCase: mockRecoveryPasswordUseCase,
    );
  });

  group('RecoveryPasswordController', () {
    group('Sucesso', () {
      test(
        'deve chamar recoveryPasswordUseCase com sucesso quando email é válido',
        () async {
          // arrange
          const email = 'test@example.com';

          when(
            () => mockRecoveryPasswordUseCase.call(email),
          ).thenAnswer((_) async {});

          // act
          await recoveryPasswordController.recoveryPassword(email: email);

          // assert
          verify(() => mockRecoveryPasswordUseCase.call(email)).called(1);
        },
      );
    });

    group('Erro', () {
      test(
        'deve propagar exceção quando recoveryPasswordUseCase falhar',
        () async {
          // arrange
          const email = 'test@example.com';

          final exception = BaseException(
            message: 'email_not_found',
          );

          when(
            () => mockRecoveryPasswordUseCase.call(email),
          ).thenThrow(exception);

          // act & assert
          expect(
            () => recoveryPasswordController.recoveryPassword(email: email),
            throwsA(isA<BaseException>()),
          );

          verify(() => mockRecoveryPasswordUseCase.call(email)).called(1);
        },
      );

      test(
        'deve propagar exceção de rede quando falha de conexão',
        () async {
          // arrange
          const email = 'test@example.com';

          final exception = BaseException(
            message: 'network_error',
          );

          when(
            () => mockRecoveryPasswordUseCase.call(email),
          ).thenThrow(exception);

          // act & assert
          expect(
            () => recoveryPasswordController.recoveryPassword(email: email),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test(
        'deve propagar exceção quando email é inválido',
        () async {
          // arrange
          const email = 'invalid-email';

          final exception = BaseException(
            message: 'invalid_email_format',
          );

          when(
            () => mockRecoveryPasswordUseCase.call(email),
          ).thenThrow(exception);

          // act & assert
          expect(
            () => recoveryPasswordController.recoveryPassword(email: email),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });
  });
}
