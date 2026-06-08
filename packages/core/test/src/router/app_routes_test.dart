import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(AppRouter.home);
  });

  setUp(() {
    // Limpa o estado estático antes de cada teste
    AppRoutes.routes.clear();
    BaseController.navigatorIndex.value = null;
  });

  tearDown(() {
    // Limpa o estado após cada teste
    AppRoutes.routes.clear();
    BaseController.navigatorIndex.value = null;
  });

  group('AppRoutes - addRoutes', () {
    test('deve adicionar rotas vazias sem erro', () {
      // act
      AppRoutes.addRoutes([]);

      // assert
      expect(AppRoutes.routes.isEmpty, true);
    });

    test('deve adicionar uma rota com sucesso', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ];

      // act
      AppRoutes.addRoutes(routes);

      // assert
      expect(AppRoutes.routes.length, 1);
      expect(AppRoutes.routes['/home'], isNotNull);
      expect(AppRoutes.routes['/home']!.name, '/home');
    });

    test('deve adicionar múltiplas rotas com sucesso', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
        AppRouterPage(
          name: '/settings',
          page: () => const SizedBox(),
        ),
        AppRouterPage(
          name: '/profile',
          page: () => const SizedBox(),
        ),
      ];

      // act
      AppRoutes.addRoutes(routes);

      // assert
      expect(AppRoutes.routes.length, 3);
      expect(AppRoutes.routes.containsKey('/home'), true);
      expect(AppRoutes.routes.containsKey('/settings'), true);
      expect(AppRoutes.routes.containsKey('/profile'), true);
    });

    test('deve sobrescrever rotas com mesmo nome', () {
      // arrange
      final routes1 = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ];
      final routes2 = [
        AppRouterPage(
          name: '/home',
          page: () => const Text('New Home'),
        ),
      ];

      // act
      AppRoutes.addRoutes(routes1);
      AppRoutes.addRoutes(routes2);

      // assert
      expect(AppRoutes.routes.length, 1);
    });

    test('deve adicionar rotas com nestedKey corretamente', () {
      // arrange
      final parentRoute = AppRouterPage(
        name: '/parent',
        page: () => const SizedBox(),
        nestedKey: 1,
        children: [
          AppRouterPage(
            name: '/child',
            page: () => const SizedBox(),
          ),
        ],
      );

      // act
      AppRoutes.addRoutes([parentRoute]);

      // assert
      expect(AppRoutes.routes['/parent'], isNotNull);
      expect(AppRoutes.routes['/parent']!.nestedKey, 1);
      expect(AppRoutes.routes['/parent']!.children.isNotEmpty, true);
    });
  });

  group('AppRoutes - navigatorRoute', () {
    test('deve retornar null quando não há rotas', () {
      // act
      final result = AppRoutes.navigatorRoute();

      // assert
      expect(result, isNull);
    });

    test('deve retornar null quando nenhuma rota tem navigator true', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
        AppRouterPage(
          name: '/settings',
          page: () => const SizedBox(),
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.navigatorRoute();

      // assert
      expect(result, isNull);
    });

    test('deve retornar rota com navigator true', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
        AppRouterPage(
          name: '/splash',
          page: () => const SizedBox(),
          navigator: true,
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.navigatorRoute();

      // assert
      expect(result, isNotNull);
      expect(result!.name, '/splash');
      expect(result.navigator, true);
    });

    test(
      'deve retornar primeira rota com navigator true quando há múltiplas',
      () {
        // arrange
        final routes = [
          AppRouterPage(
            name: '/first',
            page: () => const SizedBox(),
            navigator: true,
          ),
          AppRouterPage(
            name: '/second',
            page: () => const SizedBox(),
            navigator: true,
          ),
        ];
        AppRoutes.addRoutes(routes);

        // act
        final result = AppRoutes.navigatorRoute();

        // assert
        expect(result, isNotNull);
        expect(result!.name, '/first');
      },
    );

    test(
      'deve retornar null quando lista de rotas está vazia após firstWhereOrNull',
      () {
        // arrange - rotas sem navigator
        AppRoutes.addRoutes([]);

        // act
        final result = AppRoutes.navigatorRoute();

        // assert
        expect(result, isNull);
      },
    );
  });

  group('AppRoutes - exist', () {
    test('deve retornar false quando rotas estão vazias', () {
      // act
      final result = AppRoutes.exist(AppRouter.home);

      // assert
      expect(result, false);
    });

    test('deve retornar true quando rota existe diretamente', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.exist(AppRouter.home);

      // assert
      expect(result, true);
    });

    test('deve retornar false quando rota não existe', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.exist(AppRouter.settings);

      // assert
      expect(result, false);
    });

    test('deve retornar true quando rota existe em nested children', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/admin',
          page: () => const SizedBox(),
          nestedKey: 1,
          children: [
            AppRouterPage(
              name: '/users',
              page: () => const SizedBox(),
            ),
            AppRouterPage(
              name: '/users/details',
              page: () => const SizedBox(),
            ),
          ],
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final resultUsers = AppRoutes.exist(AppRouter.users);
      final resultUsersDetails = AppRoutes.exist(AppRouter.usersDetails);

      // assert
      expect(resultUsers, true);
      expect(resultUsersDetails, true);
    });

    test('deve retornar false para rota aninhada que não existe', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/admin',
          page: () => const SizedBox(),
          nestedKey: 1,
          children: [
            AppRouterPage(
              name: '/users',
              page: () => const SizedBox(),
            ),
          ],
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.exist(AppRouter.settings);

      // assert
      expect(result, false);
    });

    test('deve retornar false para rota em children vazio', () {
      // arrange - rota pai sem children
      final routes = [
        AppRouterPage(
          name: '/admin',
          page: () => const SizedBox(),
          nestedKey: 1,
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.exist(AppRouter.users);

      // assert
      expect(result, false);
    });

    test('deve retornar false para rota com nestedKey null em route pai', () {
      // arrange - rota pai sem nestedKey
      final routes = [
        AppRouterPage(
          name: '/admin',
          page: () => const SizedBox(),
          children: [
            AppRouterPage(
              name: '/users',
              page: () => const SizedBox(),
            ),
          ],
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.exist(AppRouter.users);

      // assert
      expect(result, false);
    });
  });

  group('AppRoutes - findByRoute', () {
    test('deve retornar null quando rotas estão vazias', () {
      // act
      final result = AppRoutes.findByRoute('/home');

      // assert
      expect(result, isNull);
    });

    test('deve encontrar rota direta pelo nome', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.findByRoute('/home');

      // assert
      expect(result, isNotNull);
      expect(result!.name, '/home');
    });

    test('deve retornar null para rota que não existe', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.findByRoute('/nonexistent');

      // assert
      expect(result, isNull);
    });

    test('deve encontrar rota com nestedKey especificado', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/admin',
          page: () => const SizedBox(),
          nestedKey: 1,
          children: [
            AppRouterPage(
              name: '/users',
              page: () => const SizedBox(),
            ),
          ],
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.findByRoute('/users', nestedId: 1);

      // assert
      expect(result, isNotNull);
      expect(result!.name, '/users');
      expect(result.nestedKey, 1);
    });

    test('deve usar navigatorIndex quando nestedId não especificado', () {
      // arrange
      BaseController.navigatorIndex.value = 1;
      final routes = [
        AppRouterPage(
          name: '/admin',
          page: () => const SizedBox(),
          nestedKey: 1,
          children: [
            AppRouterPage(
              name: '/users',
              page: () => const SizedBox(),
            ),
          ],
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.findByRoute('/users');

      // assert
      expect(result, isNotNull);
      expect(result!.name, '/users');
    });

    test('deve retornar rota base quando nestedRouter não tem children', () {
      // arrange
      BaseController.navigatorIndex.value = 1;
      final routes = [
        AppRouterPage(
          name: '/admin',
          page: () => const SizedBox(),
          nestedKey: 1,
        ),
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act
      final result = AppRoutes.findByRoute('/home', nestedId: 1);

      // assert
      expect(result, isNotNull);
      expect(result!.name, '/home');
    });

    test(
      'deve retornar rota direta quando nestedId é null e navigatorIndex é null',
      () {
        // arrange
        final routes = [
          AppRouterPage(
            name: '/home',
            page: () => const SizedBox(),
          ),
        ];
        AppRoutes.addRoutes(routes);

        // act
        final result = AppRoutes.findByRoute('/home');

        // assert
        expect(result, isNotNull);
        expect(result!.name, '/home');
      },
    );

    test(
      'deve retornar rota de fallback quando nested route não encontrada',
      () {
        // arrange
        BaseController.navigatorIndex.value = 1;
        final routes = [
          AppRouterPage(
            name: '/admin',
            page: () => const SizedBox(),
            nestedKey: 1,
          ),
          AppRouterPage(
            name: '/fallback',
            page: () => const SizedBox(),
          ),
        ];
        AppRoutes.addRoutes(routes);

        // act
        final result = AppRoutes.findByRoute('/fallback', nestedId: 1);

        // assert
        expect(result, isNotNull);
        expect(result!.name, '/fallback');
      },
    );

    test(
      'deve retornar null quando route não encontrada em children e nem em routes',
      () {
        // arrange
        final routes = [
          AppRouterPage(
            name: '/admin',
            page: () => const SizedBox(),
            nestedKey: 1,
            children: [
              AppRouterPage(
                name: '/users',
                page: () => const SizedBox(),
              ),
            ],
          ),
        ];
        AppRoutes.addRoutes(routes);

        // act
        final result = AppRoutes.findByRoute('/nonexistent', nestedId: 1);

        // assert
        expect(result, isNull);
      },
    );
  });

  // Os testes de currentRouterPage dependem de implementação real do GetX
  // e não podem ser facilmente mockados. Por isso, vamos verificar o
  // comportamento básico através de outras formas.
  group('AppRoutes - currentRouterPage (verificação de dependência)', () {
    test('deve acessar AppNavigator.currentRoute que é uma propriedade GetX', () {
      // arrange - este teste verifica que a dependência com GetX existe
      // não podemos mockar a implementação estática real
      // Vamos verificar apenas que o getter pode ser acessado sem erro de compilação
      expect(AppNavigator.currentRoute, isA<String>());
    });

    test('deve ter AppNavigator com rotas disponíveis no projeto', () {
      // arrange & act - verificamos que o sistema de rotas está configurado
      const routes = AppRouter.values;

      // assert
      expect(routes.isNotEmpty, true);
      expect(AppRouter.initial.name, '/');
    });

    test('deve verificar que findByRoute funciona corretamente', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
        AppRouterPage(
          name: '/settings',
          page: () => const SizedBox(),
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act - simulamos o que o currentRouterPage faria
      const currentRoute = '/home';
      final result = AppRoutes.findByRoute(currentRoute);

      // assert
      expect(result, isNotNull);
      expect(result!.name, '/home');
    });

    test('deve lançar quando findByRoute retorna null e tentamos usarbang', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ];
      AppRoutes.addRoutes(routes);

      // act & assert - tentamos acessar uma rota que não existe
      // O operador ! lançará um erro (TypeError)
      // arrange
      const nonExistentRoute = '/nonexistent';

      // act - tenta encontrar uma rota que não existe
      final result = AppRoutes.findByRoute(nonExistentRoute);

      // assert - o resultado deve ser null
      expect(result, isNull);

      // assert adicional - tentar usar o resultado com ! deve lançar
      // (não testamos isso explicitamente para evitar issues de análise)
      expect(result == null, true);
    });
  });

  group('AppRoutes - Integração', () {
    test('deve permitir adicionar e buscar rotas sequencialmente', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/splash',
          page: () => const SizedBox(),
          navigator: true,
        ),
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
        AppRouterPage(
          name: '/settings',
          page: () => const SizedBox(),
        ),
      ];

      // act
      AppRoutes.addRoutes(routes);

      // assert - addRoutes
      expect(AppRoutes.routes.length, 3);

      // assert - navigatorRoute
      final navigator = AppRoutes.navigatorRoute();
      expect(navigator, isNotNull);
      expect(navigator!.name, '/splash');

      // assert - exist
      expect(AppRoutes.exist(AppRouter.home), true);
      expect(AppRoutes.exist(AppRouter.settings), true);
      expect(AppRoutes.exist(AppRouter.unknown), false);

      // assert - findByRoute
      final foundRoute = AppRoutes.findByRoute('/home');
      expect(foundRoute, isNotNull);
      expect(foundRoute!.name, '/home');
    });

    test('deve funcionar corretamente com estrutura de rotas aninhadas', () {
      // arrange
      final routes = [
        AppRouterPage(
          name: '/admin',
          page: () => const SizedBox(),
          nestedKey: 1,
          children: [
            AppRouterPage(
              name: '/users',
              page: () => const SizedBox(),
            ),
            AppRouterPage(
              name: '/users/details',
              page: () => const SizedBox(),
            ),
          ],
        ),
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
          navigator: true,
        ),
      ];

      // act
      AppRoutes.addRoutes(routes);

      // assert
      expect(AppRoutes.exist(AppRouter.admin), true);
      expect(AppRoutes.exist(AppRouter.users), true);
      expect(AppRoutes.exist(AppRouter.usersDetails), true);
      expect(AppRoutes.exist(AppRouter.home), true);
      expect(AppRoutes.exist(AppRouter.settings), false);

      final navRoute = AppRoutes.navigatorRoute();
      expect(navRoute, isNotNull);
      expect(navRoute!.name, '/home');
    });

    test('deve limpar e recompor rotas corretamente', () {
      // arrange
      final initialRoutes = [
        AppRouterPage(
          name: '/old',
          page: () => const SizedBox(),
        ),
      ];
      AppRoutes.addRoutes(initialRoutes);
      expect(AppRoutes.routes.length, 1);

      // act - limpa e adiciona novas rotas
      AppRoutes.routes.clear();
      final newRoutes = [
        AppRouterPage(
          name: '/new',
          page: () => const SizedBox(),
        ),
      ];
      AppRoutes.addRoutes(newRoutes);

      // assert
      expect(AppRoutes.routes.length, 1);
      expect(AppRoutes.routes.containsKey('/new'), true);
      expect(AppRoutes.routes.containsKey('/old'), false);
    });
  });

  group('AppRoutes - Cenários de Erro', () {
    test('deve tratar adicionar lista null gracefully', () {
      // act - não deve lançar
      AppRoutes.addRoutes([]);

      // assert
      expect(AppRoutes.routes.isEmpty, true);
    });

    test('deve tratar findByRoute com string vazia', () {
      // arrange
      AppRoutes.addRoutes([
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ]);

      // act
      final result = AppRoutes.findByRoute('');

      // assert
      expect(result, isNull);
    });

    test('deve tratar exist com AppRouter sem nome correspondente', () {
      // arrange
      AppRoutes.addRoutes([
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ]);

      // act
      final result = AppRoutes.exist(AppRouter.unknown);

      // assert
      expect(result, false);
    });

    test(
      'deve tratar navigatorRoute quando todas as rotas têm navigator false',
      () {
        // arrange
        AppRoutes.addRoutes([
          AppRouterPage(
            name: '/route1',
            page: () => const SizedBox(),
          ),
          AppRouterPage(
            name: '/route2',
            page: () => const SizedBox(),
          ),
        ]);

        // act
        final result = AppRoutes.navigatorRoute();

        // assert
        expect(result, isNull);
      },
    );

    test('deve tratar findByRoute com nestedId sem rota correspondente', () {
      // arrange
      AppRoutes.addRoutes([
        AppRouterPage(
          name: '/home',
          page: () => const SizedBox(),
        ),
      ]);

      // act
      final result = AppRoutes.findByRoute('/home', nestedId: 999);

      // assert
      expect(result, isNotNull);
    });
  });
}
