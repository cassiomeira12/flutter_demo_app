# Presentation Bindings

## Visão Geral

O Flutter Demo App possui dois níveis de bindings para injeção de dependências:

1. **Module Bindings** (`ModuleBinding`) — registro de dependências de infraestrutura e domínio, executado uma vez na inicialização do app
2. **Page Bindings** (`Bindings` do GetX) — registro de dependências específicas de uma tela, executado ao navegar para a página

Ambos usam a API `AppBinding` (extension sobre `AppBaseBinding`) que abstrai o container de DI.

## API AppBinding

| Método                                              | Descrição                                 |
| --------------------------------------------------- | ----------------------------------------- |
| `AppBinding.put<T>(dep, {tag, permanent})`          | Registra instância (singleton)            |
| `AppBinding.find<T>({tag})`                         | Recupera dependência registrada           |
| `AppBinding.lazyPut<T>(builder, {tag, fenix})`      | Singleton lazy (fenix recria após delete) |
| `AppBinding.create<T>(builder, {tag, permanent})`   | Factory                                   |
| `AppBinding.putAsync<T>(builder, {tag, permanent})` | Singleton assíncrono                      |
| `AppBinding.delete<T>({tag, force})`                | Remove do container                       |
| `AppBinding.hasInstance<T>({tag})`                  | Verifica se está registrado               |

**Import**: `package:core/core.dart`

## Module Bindings

Registram dependências de **infraestrutura e domínio** que são compartilhadas entre features. Executados uma vez na inicialização do app.

### Interface

```dart
abstract class ModuleBinding {
  Future<void> injectDependencies();
}
```

### Padrão de Nomenclatura

| Tipo           | Padrão                  | Exemplo                                       |
| -------------- | ----------------------- | --------------------------------------------- |
| Module Binding | Sufixo `ModuleBindings` | `DomainModuleBindings`, `InfraModuleBindings` |

### Exemplo: DomainModuleBindings

```dart
import 'package:core/core.dart';

class DomainModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AppBinding.lazyPut<LoginUseCase>(
      () => LoginUseCaseImpl(
        loginService: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        userService: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<LogoutUseCase>(
      () => LogoutUseCaseImpl(
        logoutService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<LocalStorageUseCase>(
      () => LocalStorageUseCaseImpl(
        localStorageService: AppBinding.find(),
      ),
    );
  }
}
```

### Exemplo: ModuleBinding vazio

Quando a feature não tem dependências cross-cutting para registrar:

```dart
class SecurityModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {}
}
```

## Page Bindings

Registram dependências **específicas de uma tela** (controllers, serviços locais). Estendem `Bindings` do GetX e são executados ao navegar para a página.

### Interface

```dart
abstract class Bindings {
  void dependencies();  // síncrono
}
```

### Padrão de Nomenclatura

| Tipo         | Padrão            | Exemplo                              |
| ------------ | ----------------- | ------------------------------------ |
| Page Binding | Sufixo `Bindings` | `SecurityBindings`, `SplashBindings` |

### Exemplo: Binding com dependências

```dart
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class SecurityBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<LocalAuthService>(LocalAuthServiceImpl());

    AppBinding.put<CheckBiometricsUseCase>(
      CheckBiometricsUseCase(localAuthService: AppBinding.find()),
    );

    AppBinding.put<AuthenticateBiometricUseCase>(
      AuthenticateBiometricUseCase(localAuthService: AppBinding.find()),
    );

    AppBinding.put<SecurityController>(
      SecurityController(
        localStorageUseCase: AppBinding.find(),
        checkBiometricsUseCase: AppBinding.find(),
        authenticateBiometricUseCase: AppBinding.find(),
        logoutUseCase: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
      ),
    );
  }
}
```

### Exemplo: Binding simplificado (apenas controller)

```dart
class SplashBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<SplashController>(
      SplashController(
        localStorageUseCase: AppBinding.find(),
        sessionEntity: AppBinding.find(),
        getInstallationAppUseCase: AppBinding.find(),
        // ... outras dependências já registradas nos ModuleBindings
      ),
    );
  }
}
```

### Exemplo: Binding com permanent

```dart
class WebViewBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<CustomNavigatorCallback>(
      CustomNavigatorCallbackImpl(),
      permanent: true, // sobrevive ao dispose da rota
    );
  }
}
```

## Estrutura de Diretórios

```
packages/feature_name/lib/src/
├── module_bindings.dart              # implements ModuleBinding
└── presentation/
    └── feature_name/
        ├── feature_name_bindings.dart  # extends Bindings
        ├── feature_name_controller.dart
        ├── feature_name_page.dart
        └── feature_name.dart           # barrel
```

## Ordem de Execução

1. `AppBindings` (raiz em `lib/app/`) chama todos os `ModuleBinding.injectDependencies()` em ordem
2. Ao navegar para uma rota, o GetX executa o `Bindings.dependencies()` correspondente
3. Dentro de cada binding, as dependências são resolvidas via `AppBinding.find<T>()` — DEVEM já estar registradas por ModuleBindings anteriores

## Boas Práticas

1. **ModuleBindings**: Usar `AppBinding.lazyPut` para use cases e serviços (criam sob demanda)
2. **Page Bindings**: Usar `AppBinding.put` para controllers (são específicos da tela)
3. **`permanent: true`**: Usar apenas para serviços que devem sobreviver ao ciclo de vida da rota
4. **ModuleBindings vazios**: Ok quando a feature não tem dependências cross-cutting
5. **Ordem de registro**: Dependências devem ser registradas antes de serem injetadas
6. **Nunca instanciar dependências diretamente**: Sempre usar `AppBinding.find()`

## Checklist para Criar um Novo Binding

### Module Binding

- [ ] Nome segue padrão `XxxModuleBindings`
- [ ] Implementa `ModuleBinding`
- [ ] Método `injectDependencies()` async
- [ ] Use cases registrados com `AppBinding.lazyPut`
- [ ] Serviços compartilhados com `AppBinding.put` ou `AppBinding.lazyPut`

### Page Binding

- [ ] Nome segue padrão `XxxBindings`
- [ ] Estende `Bindings` (GetX)
- [ ] Controller registrado com `AppBinding.put<XxxController>`
- [ ] Dependências específicas da tela registradas antes do controller
- [ ] Dependências já existentes resolvidas com `AppBinding.find()`

---

**Veja também**: [Controllers](controllers.md) | [Page](page.md) | [Domain ModuleBindings](../domain/README.md#-module-bindings-injeção-de-dependências) | [Infra ModuleBindings](../infra/infra.md#-module-bindings-injeção-de-dependências)
