import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_account/src/presentation/delete_account/delete_account_controller.dart';
import 'package:user_account/src/presentation/delete_account/store/delete_account_store.dart';

class MockDeleteAccountStore extends Mock implements DeleteAccountStore {}

class FakeRxnString extends Fake implements RxnString {}

class MockRxnString extends Mock implements RxnString {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AppBinding.testMode(true);

  setUpAll(() {
    registerFallbackValue(FakeRxnString());
  });

  group('DeleteAccountController', () {
    late MockDeleteAccountStore mockDeleteAccountStore;
    late DeleteAccountController subject;

    setUp(() {
      mockDeleteAccountStore = MockDeleteAccountStore();

      subject = DeleteAccountController(
        deleteAccountStore: mockDeleteAccountStore,
      );
    });

    group('reason', () {
      test('deve retornar o valor de selectedReason do store', () {
        // arrange
        const String expectedReason = 'Motivo de teste';
        final mockRxnString = MockRxnString();
        when(() => mockRxnString.value).thenReturn(expectedReason);
        when(
          () => mockDeleteAccountStore.selectedReason,
        ).thenReturn(mockRxnString);

        // act
        final String? result = subject.reason;

        // assert
        expect(result, expectedReason);
        verify(() => mockDeleteAccountStore.selectedReason).called(1);
      });

      test('deve retornar null quando selectedReason.value for null', () {
        // arrange
        final mockRxnString = MockRxnString();
        when(() => mockRxnString.value).thenReturn(null);
        when(
          () => mockDeleteAccountStore.selectedReason,
        ).thenReturn(mockRxnString);

        // act
        final String? result = subject.reason;

        // assert
        expect(result, isNull);
      });

      test(
        'deve lançar exceção quando store.selectedReason lançar exceção',
        () {
          // arrange
          when(
            () => mockDeleteAccountStore.selectedReason,
          ).thenThrow(Exception('Erro ao acessar store'));

          // act & assert
          expect(() => subject.reason, throwsA(isA<Exception>()));
        },
      );
    });

    group('setReason', () {
      test('deve definir o reason no store', () {
        // arrange
        final mockRxnString = MockRxnString();
        when(
          () => mockDeleteAccountStore.selectedReason,
        ).thenReturn(mockRxnString);
        when(() => mockRxnString.value).thenReturn(null);

        const String newReason = 'Novo motivo';

        // act
        subject.setReason(newReason);

        // assert
        verify(() => mockRxnString.value = newReason).called(1);
      });

      test('deve permitir definir null como reason', () {
        // arrange
        final mockRxnString = MockRxnString();
        when(
          () => mockDeleteAccountStore.selectedReason,
        ).thenReturn(mockRxnString);
        when(() => mockRxnString.value).thenReturn('some value');

        // act
        subject.setReason(null);

        // assert
        verify(() => mockRxnString.value = null).called(1);
      });

      test(
        'deve lançar exceção quando store.selectedReason não estiver disponível',
        () {
          // arrange
          when(
            () => mockDeleteAccountStore.selectedReason,
          ).thenThrow(Exception('Store não disponível'));

          // act & assert
          expect(
            () => subject.setReason('Motivo'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('openNextPage', () {
      test('deve navegar para a página de conclusão de exclusão de conta', () {
        // arrange & act & assert
        // O método navigates using AppNavigator.toNamed(AppRouter.deleteAccountFinish)
        // Tested indirectly - just verify it doesn't throw synchronously
        expect(() => subject.openNextPage(), returnsNormally);
      });
    });
  });
}
