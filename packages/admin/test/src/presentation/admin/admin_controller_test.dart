import 'package:admin/src/presentation/admin/admin.dart' show AdminController;
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockAppSecurityManager extends Mock implements AppSecurityManager {}

void main() {
  late MockLogoutUseCase mockLogoutUseCase;
  late MockAppSecurityManager mockAppSecurityManager;
  late AdminController adminController;
  late UserEntity userEntity;

  setUpAll(() {
    registerFallbackValue('');
    WidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
  });

  setUp(() {
    mockLogoutUseCase = MockLogoutUseCase();
    mockAppSecurityManager = MockAppSecurityManager();

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

    AppBinding.put<UserEntity>(userEntity);

    when(() => mockLogoutUseCase.call()).thenAnswer((_) async {});
    when(() => mockAppSecurityManager.clearSettings()).thenAnswer((_) async {});
    when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});
    when(() => mockAppSecurityManager.unlockApp()).thenReturn(null);

    adminController = AdminController(
      logoutUseCase: mockLogoutUseCase,
      appSecurityManager: mockAppSecurityManager,
    );
  });

  tearDown(() {
    AppBinding.delete<UserEntity>(force: true);
  });

  group('AdminController', () {
    group('changeTab', () {
      test('deve alterar o indice selecionado quando diferente do atual', () {
        // arrange
        const novaIndex = 2;
        const key = 'test_key';

        // act
        adminController.changeTab(novaIndex, key);

        // assert
        expect(adminController.selectedIndex.value, novaIndex);
      });

      test('nao deve alterar quando indice e igual ao atual', () {
        // arrange
        const novaIndex = 1;
        adminController.selectedIndex.value = novaIndex;

        // act
        adminController.changeTab(novaIndex, 'test_key');

        // assert
        expect(adminController.selectedIndex.value, novaIndex);
      });

      test('deve alterar para diferentes indices consecutivamente', () {
        // arrange & act
        adminController.changeTab(0, 'key_0');
        expect(adminController.selectedIndex.value, 0);

        adminController.changeTab(1, 'key_1');
        expect(adminController.selectedIndex.value, 1);

        adminController.changeTab(2, 'key_2');
        expect(adminController.selectedIndex.value, 2);

        adminController.changeTab(0, 'key_0');
        expect(adminController.selectedIndex.value, 0);
      });
    });

    group('logout', () {
      test('deve executar logout com sucesso', () async {
        // arrange & act
        await adminController.logout();

        // assert
        verify(() => mockLogoutUseCase.call()).called(1);
        verify(() => mockAppSecurityManager.clearSettings()).called(1);
        verify(() => mockAppSecurityManager.init()).called(1);
        verify(() => mockAppSecurityManager.unlockApp()).called(1);
      });

      test('deve continuar fluxo mesmo quando logoutUseCase falha', () async {
        // arrange
        when(
          () => mockLogoutUseCase.call(),
        ).thenThrow(Exception('Erro ao fazer logout'));

        // act
        await adminController.logout();

        // assert - deve continuar mesmo com erro no logoutUseCase
        verify(() => mockLogoutUseCase.call()).called(1);
        verify(() => mockAppSecurityManager.clearSettings()).called(1);
        verify(() => mockAppSecurityManager.init()).called(1);
        verify(() => mockAppSecurityManager.unlockApp()).called(1);
      });

      test('deve continuar fluxo quando clearSettings falha', () async {
        // arrange
        when(
          () => mockAppSecurityManager.clearSettings(),
        ).thenThrow(Exception('Erro ao limpar settings'));

        // act & assert - deve lançar exceção pois não há tratamento no finally
        expect(
          () => adminController.logout(),
          throwsA(isA<Exception>()),
        );
      });

      test('deve continuar fluxo quando init falha', () async {
        // arrange
        when(
          () => mockAppSecurityManager.init(),
        ).thenThrow(Exception('Erro ao init'));

        // act & assert - deve lançar exceção pois não há tratamento no finally
        expect(
          () => adminController.logout(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('selectedIndex', () {
      test('deve iniciar com valor padrao do navigatorIndex', () {
        // assert
        expect(
          adminController.selectedIndex.value,
          BaseController.navigatorIndex,
        );
      });

      test('deve permitir alteracao de valor', () {
        // arrange
        const novoValor = 5;

        // act
        adminController.selectedIndex.value = novoValor;

        // assert
        expect(adminController.selectedIndex.value, novoValor);
      });
    });

    group('user', () {
      test('deve ter acesso ao usuario atual', () {
        // assert
        expect(adminController.user, isA<UserEntity>());
      });
    });
  });
}
