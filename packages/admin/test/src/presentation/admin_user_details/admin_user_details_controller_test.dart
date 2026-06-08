import 'package:admin/src/presentation/admin_user_details/admin_user_details.dart';
import 'package:admin/src/presentation/users/users.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

// Stub para UsersStore - usando extensão ao invés de implementação
class StubUsersStore extends UsersStore {}

void main() {
  late StubUsersStore stubUsersStore;
  late AdminUserDetailsController adminUserDetailsController;
  late UserEntity userEntity;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
  });

  setUp(() {
    stubUsersStore = StubUsersStore();

    userEntity = UserEntity(
      id: 'test_id',
      username: 'test_user',
      name: 'Test User',
      email: 'test@example.com',
      avatarUrl: 'https://example.com/avatar.png',
      createdAt: '2024-01-01',
      updatedAt: '2024-01-01',
      permissions: [UserPermissionsEnum.USER],
      locale: 'en',
      sessionToken: 'test_token',
      pushTopics: [],
    );

    stubUsersStore.userSelected = userEntity;

    adminUserDetailsController = AdminUserDetailsController(
      userStore: stubUsersStore,
    );
  });

  group('AdminUserDetailsController', () {
    group('user', () {
      test('deve retornar o usuario selecionado quando existente', () {
        // arrange
        stubUsersStore.userSelected = userEntity;

        // act
        final result = adminUserDetailsController.user;

        // assert
        expect(result, same(userEntity));
        expect(result.id, 'test_id');
        expect(result.email, 'test@example.com');
      });

      test('deve lanar excecao quando usuario selecionado e nulo', () {
        // arrange
        stubUsersStore.userSelected = null;

        // act & assert - o código lança um TypeError (null check operator)
        expect(
          () => adminUserDetailsController.user,
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('changePassword', () {
      test('deve executar sem erro', () {
        // arrange & act & assert
        expect(
          () => adminUserDetailsController.changePassword(),
          returnsNormally,
        );
      });
    });

    group('deleteAccount', () {
      test('deve executar sem erro', () {
        // arrange & act & assert
        expect(
          () => adminUserDetailsController.deleteAccount(),
          returnsNormally,
        );
      });
    });

    group('openUserInstallations', () {
      test('deve executar sem erro', () {
        // arrange & act & assert
        expect(
          () => adminUserDetailsController.openUserInstallations(),
          returnsNormally,
        );
      });
    });
  });
}
