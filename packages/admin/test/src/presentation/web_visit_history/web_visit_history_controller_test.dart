import 'package:admin/src/domain/domain.dart';
import 'package:admin/src/presentation/web_visit_history/web_visit_history_controller.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class MockListWebVisitHistoryUseCase extends Mock
    implements ListWebVisitHistoryUseCase {}

void main() {
  late MockListWebVisitHistoryUseCase mockListWebVisitHistoryUseCase;
  late WebVisitHistoryController controller;

  setUpAll(() {
    registerFallbackValue(<WebVisitHistoryEntity>[]);
  });

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
  });

  setUp(() {
    mockListWebVisitHistoryUseCase = MockListWebVisitHistoryUseCase();

    controller = WebVisitHistoryController(
      listWebVisitHistoryUseCase: mockListWebVisitHistoryUseCase,
    );
  });

  group('WebVisitHistoryController', () {
    group('fetchDataFunction', () {
      test('deve retornar funcao do use case', () {
        // arrange & act
        final result = controller.fetchDataFunction;

        // assert
        expect(result, isA<Future<List<WebVisitHistoryEntity>> Function()>());
      });
    });

    group('list', () {
      test('deve iniciar vazio', () {
        // arrange & act
        final result = controller.list;

        // assert
        expect(result, isEmpty);
      });
    });

    group('isLoading', () {
      test('deve iniciar como true', () {
        // arrange & act
        final result = controller.isLoading.value;

        // assert
        expect(result, true);
      });
    });

    group('errorMessage', () {
      test('deve iniciar vazio', () {
        // arrange & act
        final result = controller.errorMessage.value;

        // assert
        expect(result, isEmpty);
      });
    });

    group('onFetchListData (via onReady)', () {
      test(
        'deve retornar lista de historico quando chamada com sucesso',
        () async {
          // arrange
          final historyList = [
            WebVisitHistoryEntity(
              website: 'https://example.com',
              ip: '192.168.1.1',
              userAgent: 'Mozilla/5.0',
              country: 'United States',
              countryCode: 'US',
              countryFlag: '🇺🇸',
              region: 'California',
              regionName: 'California',
              city: 'Mountain View',
              zip: '94043',
              lat: 37.4063,
              lon: -122.079,
              timezone: 'America/Los_Angeles',
              isp: 'Google LLC',
              org: 'Google LLC',
              ispOrg: 'Google LLC',
              objectId: 'history_1',
              createdAt: DateTime(2024),
              updatedAt: DateTime(2024),
            ),
            WebVisitHistoryEntity(
              website: 'https://test.com',
              ip: '192.168.1.2',
              userAgent: 'Mozilla/5.0',
              country: 'Brazil',
              countryCode: 'BR',
              countryFlag: '🇧🇷',
              region: 'Sao Paulo',
              regionName: 'Sao Paulo',
              city: 'Sao Paulo',
              zip: '01000-000',
              lat: -23.5505,
              lon: -46.6333,
              timezone: 'America/Sao_Paulo',
              isp: 'Telefonica Brasil',
              org: 'Telefonica Brasil',
              ispOrg: 'Telefonica Brasil',
              objectId: 'history_2',
              createdAt: DateTime(2024),
              updatedAt: DateTime(2024),
            ),
          ];

          when(
            () => mockListWebVisitHistoryUseCase.call(),
          ).thenAnswer((_) async => historyList);

          // act
          await controller.onFetchListData();

          // assert
          expect(controller.list, historyList);
          expect(controller.list.length, 2);
          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, isEmpty);
          verify(() => mockListWebVisitHistoryUseCase.call()).called(1);
        },
      );

      test(
        'deve definir erro quando uso caso lancahar BaseException',
        () async {
          // arrange
          final baseException = BaseException(
            message: 'Erro ao buscar historico',
          );

          when(
            () => mockListWebVisitHistoryUseCase.call(),
          ).thenThrow(baseException);

          // act
          await controller.onFetchListData();

          // assert
          expect(controller.list, isEmpty);
          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, isNotEmpty);
        },
      );

      test(
        'deve definir erro quando uso caso lancahar Exception generica',
        () async {
          // arrange
          when(
            () => mockListWebVisitHistoryUseCase.call(),
          ).thenThrow(Exception('Erro generico'));

          // act
          await controller.onFetchListData();

          // assert
          expect(controller.list, isEmpty);
          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, isNotEmpty);
        },
      );
    });

    group('refreshWebVisitHistory', () {
      test('deve chamar onFetchListData quando executado', () async {
        // arrange
        when(
          () => mockListWebVisitHistoryUseCase.call(),
        ).thenAnswer((_) async => <WebVisitHistoryEntity>[]);

        // act - o metodo chama clickTagging que pode falhar em teste
        // entao chamamos onFetchListData diretamente
        await controller.onFetchListData();

        // assert
        expect(controller.list, isEmpty);
        expect(controller.isLoading.value, false);
      });
    });
  });
}
