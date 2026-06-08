# Testing

Propósito
- Estratégia de testes para o Flutter Demo App (unit, widget, integração).

## Comandos

```bash
# Rodar todos os testes (unit + widget)
make test

# Rodar teste em arquivo específico
make test-file

# Análise estática
make analyze
```

**Importante**: `make test` e `make test-file` exigem seleção de um arquivo `.env.*` (interativo via `make choice-env`). Os testes usam `--dart-define-from-file=<env>` para injetar configurações.

## Tipos de Teste

### Unit Tests

Testam lógica de negócio isoladamente (use cases, repositories, models, entities).

```
test/
├── domain/
│   ├── entities/
│   └── use_cases/
├── data/
│   ├── models/
│   └── repositories/
└── presentation/
    └── controllers/
```

**Exemplo:**

```dart
void main() {
  group('LoginUseCase', () {
    late LoginUseCaseImpl useCase;
    late MockUserRepository mockRepository;

    setUp(() {
      mockRepository = MockUserRepository();
      useCase = LoginUseCaseImpl(repository: mockRepository);
    });

    test('deve retornar UserEntity quando login for bem-sucedido', () async {
      // Arrange
      when(() => mockRepository.login(
        username: 'test@email.com',
        password: '123',
      )).thenAnswer((_) async => mockUser);

      // Act
      final result = await useCase.call(
        username: 'test@email.com',
        password: '123',
      );

      // Assert
      expect(result, isA<Success<UserEntity>>());
    });

    test('deve retornar Error quando login falhar', () async {
      // Arrange
      when(() => mockRepository.login(
        username: 'wrong@email.com',
        password: 'wrong',
      )).thenThrow(Exception('Invalid credentials'));

      // Act
      final result = await useCase.call(
        username: 'wrong@email.com',
        password: 'wrong',
      );

      // Assert
      expect(result, isA<Error<UserEntity>>());
    });
  });
}
```

### Widget Tests

Testam componentes de UI isoladamente.

```
test/
└── presentation/
    └── widgets/
        ├── primary_button_test.dart
        └── text_field_widget_test.dart
```

**Exemplo:**

```dart
void main() {
  testWidgets('PrimaryButton deve renderizar com label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PrimaryButton(
          label: 'Entrar',
          onPressed: () {},
        ),
      ),
    );

    expect(find.text('Entrar'), findsOneWidget);
  });
}
```

### Integration Tests

Testam fluxos completos entre múltiplas features.

```
integration_test/
└── login_flow_test.dart
```

## Padrões de Nomeclatura

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Arquivo | `*_test.dart` | `login_use_case_test.dart` |
| Grupo | `group('Classe', ...)` | `group('LoginUseCase', ...)` |
| Teste | `test('deve...', ...)` | `test('deve retornar UserEntity...', ...)` |

## Mocking

Usar `mocktail` para mocks:

```dart
class MockUserRepository extends Mock implements UserRepository {}

 setUp(() {
  mockRepository = MockUserRepository();
});
```

## Cobertura

- Manter cobertura mínima de 80% para novas features
- Priorizar testes de lógica de negócio (use cases, repositories)
- Testes de widget para componentes complexos

## Estrutura de Diretórios

```
test/
├── data/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── use_cases/
├── presentation/
│   ├── controllers/
│   └── widgets/
└── helpers/
    └── test_helpers.dart
```

---

**Ver também**: [CI/CD](../ci-cd/README.md) | [Governança](../governance.md)
