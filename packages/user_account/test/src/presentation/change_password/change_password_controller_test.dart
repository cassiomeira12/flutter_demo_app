import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_account/src/presentation/change_password/change_password_controller.dart';

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

class MockUserEntity extends Mock implements UserEntity {}

void main() {
  late MockChangePasswordUseCase mockChangePasswordUseCase;
  late MockUserEntity mockUserEntity;
  late ChangePasswordController subject;

  setUp(() {
    mockChangePasswordUseCase = MockChangePasswordUseCase();
    mockUserEntity = MockUserEntity();

    AppBinding.put<UserEntity>(mockUserEntity);

    subject = ChangePasswordController(
      changePasswordUseCase: mockChangePasswordUseCase,
    );
  });

  tearDown(() {
    AppBinding.delete<UserEntity>();
  });

  group('newPasswordValidator', () {
    test('deve retornar erro quando senha nova for igual a senha atual', () {
      // arrange
      const String currentPassword = 'OldPassword123';
      const String newPassword = 'OldPassword123';

      // act
      final String? result = subject.newPasswordValidator(
        newPassword,
        currentPassword: currentPassword,
      );

      // assert
      expect(result, isNotNull);
      expect(result, 'new_password_not_be_equal_old_password');
    });

    test(
      'deve retornar null quando senha nova for diferente da senha atual',
      () {
        // arrange
        const String currentPassword = 'OldPassword123';
        const String newPassword = 'NewPassword456';

        // act
        final String? result = subject.newPasswordValidator(
          newPassword,
          currentPassword: currentPassword,
        );

        // assert
        expect(result, isNull);
      },
    );

    test('deve retornar erro quando senha nova for vazia', () {
      // arrange
      const String emptyPassword = '';

      // act
      final String? result = subject.newPasswordValidator(emptyPassword);

      // assert
      expect(result, isNotNull);
      expect(result, 'password_input_empty_error');
    });
  });

  group('changePassword', () {
    const String testEmail = 'test@example.com';
    const String testCurrentPassword = 'CurrentPassword123';
    const String testNewPassword = 'NewPassword456';

    group('Sucesso', () {
      test('deve chamar o use case com os parâmetros corretos', () async {
        // arrange
        when(() => mockUserEntity.email).thenReturn(testEmail);
        when(
          () => mockChangePasswordUseCase.call(
            username: any(named: 'username'),
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async {});

        // act
        await subject.changePassword(
          currentPassword: testCurrentPassword,
          newPassword: testNewPassword,
        );

        // assert
        verify(
          () => mockChangePasswordUseCase.call(
            username: testEmail,
            currentPassword: testCurrentPassword,
            newPassword: testNewPassword,
          ),
        ).called(1);
      });

      test(
        'deve completar sem erros quando UseCase retornar com sucesso',
        () async {
          // arrange
          when(() => mockUserEntity.email).thenReturn(testEmail);
          when(
            () => mockChangePasswordUseCase.call(
              username: any(named: 'username'),
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            ),
          ).thenAnswer((_) async {});

          // act & assert
          expect(
            () => subject.changePassword(
              currentPassword: testCurrentPassword,
              newPassword: testNewPassword,
            ),
            returnsNormally,
          );
        },
      );
    });

    group('Erro', () {
      test('deve lançar exceção quando UseCase falhar', () async {
        // arrange
        when(() => mockUserEntity.email).thenReturn(testEmail);
        when(
          () => mockChangePasswordUseCase.call(
            username: any(named: 'username'),
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenThrow(Exception('Falha ao alterar senha'));

        // act & assert
        expect(
          () => subject.changePassword(
            currentPassword: testCurrentPassword,
            newPassword: testNewPassword,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test(
        'deve lançar exceção de rede quando ocorrer erro de conexão',
        () async {
          // arrange
          when(() => mockUserEntity.email).thenReturn(testEmail);
          when(
            () => mockChangePasswordUseCase.call(
              username: any(named: 'username'),
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            ),
          ).thenThrow(Exception('Network error'));

          // act & assert
          expect(
            () => subject.changePassword(
              currentPassword: testCurrentPassword,
              newPassword: testNewPassword,
            ),
            throwsA(
              predicate((e) => e.toString().contains('Network error')),
            ),
          );
        },
      );
    });
  });
}
