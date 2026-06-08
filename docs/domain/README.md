# Clean Code Domain Package

Camada de domínio seguindo os princípios de **Clean Architecture**. Define as regras de negócio puras, entidades, contratos de repositórios, serviços e casos de uso (use cases) da aplicação.

**Veja também**: [Entities](entities.md) | [Models](../data/models.md) | [Use Cases](use-cases.md) | [Repositories](../data/repositories.md) | [Glossário](../glossary.md)

## Instalação

No `pubspec.yaml` do app principal ou pacote que consumirá o domínio:

```yaml
dependencies:
  clean_code_domain:
    path: packages/clean_code_domain
```

## Importação

```dart
import 'package:clean_code_domain/clean_code_domain.dart';
```

---

## Índice de Componentes

### 📦 Entities (Entidades de Domínio)

Entidades puras que representam as regras de negócio da aplicação.

| Entidade | Descrição |
|----------|-----------|
| `BaseEntity` | Classe abstrata base para entidades com `objectId`, `createdAt`, `updatedAt`. Estende `ParserToJson` |
| `UserEntity` | Dados do usuário: id, username, name, email, avatarUrl, permissions, locale, sessionToken, pushTopics. Estende `ParserToJson` |
| `SessionEntity` | Sessão simples com token. Método `isAuthenticated` |
| `InstallationEntity` | Dados de instalação do app (push notifications). Estende `ParserToJson`. Método `equals()` |
| `NotificationEntity` | Notificação com title, body, viewed, imageUrl. Estende `ParserToJson` |
| `PushNotificationEntity` | Configuração de push notification para Android/iOS. Estende `ParserToJson` |
| `DeviceInfoEntity` | Informações do dispositivo (brand, model, OS, locale). Estende `ParserToJson` |
| `AppInfoEntity` | Informações do app (name, package, version, build). Estende `ParserToJson`. Métodos `formattedName`, `versionOnly` |
| `IpAddressLocationEntity` | Dados de geolocalização por IP. Método factory `emptyIpAddress()` |
| `ShareResultEntity` | Resultado de compartilhamento com raw e status |
| `AppEnvironmentEntity` | Configurações de ambiente do app (appName, androidPackageName, appleStoreAppId, permissions) |
| `SecurityEnvironmentEntity` | Configurações de segurança (encryptKey, serverRSAPublicKeyBase64) |
| `ServerEnvironmentEntity` | Configurações do servidor (serverUrl, appId, clientKey, restApiKey, graphqlUrl) |
| `WebAppEnvironmentEntity` | Configurações de contato web (email, instagram, facebook, whatsapp) |

---

### 🔢 Enums (Enumerações)

| Enum | Valores | Descrição |
|------|---------|-----------|
| `UserPermissionsEnum` | `ADMIN`, `USER` | Permissões de usuário |

---

### 🔄 Parsers (Serialização)

| Classe | Descrição |
|--------|-----------|
| `ParserToJson` | Classe abstrata com método `toMap()` e `toString()` para serialização |

---

### 🗄 Repositories (Contratos de Repositórios)

Interfaces abstratas que definem contratos para acesso a dados.

| Repositório | Descrição |
|-------------|-----------|
| `BaseRepository<T>` | Interface para repositórios CRUD com `ValueNotifier`, métodos `initLocalDatabase`, `dispose`, `sort`, `encrypt`, `decrypt`, `create`, `read`, `update`, `delete`, `deleteLocalDatabase`, `fetch` |

---

### ⚙️ Services (Contratos de Serviços)

Interfaces abstratas que definem contratos para serviços da aplicação.

| Serviço | Descrição |
|---------|-----------|
| `BaseCrudService<T>` | Interface base para CRUD que implementa `CreateService`, `DeleteService`, `ListService`, `ReadService`, `UpdateService`. Método `parseMap()` |
| `UserService` | Estende `UpdateService<UserEntity>`. Métodos: `getUserData`, `deleteUser`, `changePassword` |
| `LoginService` | Método: `login(username, password)` retorna `UserEntity` |
| `LogoutService` | Método: `logout()` |
| `NotificationService` | Implementa `CreateService<NotificationEntity>`, `ListService<NotificationEntity>`. Métodos: `countUnread`, `readNotifications`, `testPush` |
| `AppInfoService` | Método: `getAppInfo()` retorna `AppInfoEntity` |
| `AppInstallationService` | Métodos: `getInstallation`, `upload`, `list` |
| `AppLocaleService` | Métodos: `getCurrentLocale`, `setLocale` |
| `AppPermissionsService` | Métodos: `checkPermission`, `requestPermission` (usa `Permission` do package dependency) |
| `DeviceInfoService` | Método: `getDeviceInfo()` retorna `DeviceInfoEntity` |
| `InternetConnectionService` | Métodos: `hasInternetAccess`, `addStream`, `pauseStream`, `resumeStream`, `dispose` |
| `IpAddressLocationService` | Método: `getIpAddress({ip})` retorna `IpAddressLocationEntity` |
| `OpenUrlService` | Métodos: `openUrl`, `openApp` |
| `UserAuthStorageService` | Métodos para salvar/recuperar credenciais e session token |
| `CacheStorageService` | Métodos: `load`, `save` |
| `ClipboardService` | Operações com área de transferência |
| `FileStorageService` | Armazenamento de arquivos |
| `LocalStorageService` | Armazenamento local chave-valor |
| `OtpCodeService` | Geração e validação de código OTP |
| `RsaEncryptService` | Criptografia RSA |
| `SecureStorageService` | Armazenamento seguro chave-valor |
| `SecurityEncryptService` | Criptografia/descriptografia de dados |
| `ShareService` | Compartilhamento de conteúdo |

---

### 🎯 Use Cases (Contratos de Casos de Uso)

Interfaces abstratas que definem contratos para casos de uso específicos da aplicação.

#### **Base Use Cases**

| Use Case | Descrição |
|----------|-----------|
| `BaseUseCaseSync<R>` | Use case síncrono sem parâmetros |
| `BaseUseCaseSyncParam<R, P>` | Use case síncrono com parâmetro |
| `BaseUseCaseAsync<R>` | Use case assíncrono sem parâmetros |
| `BaseUseCaseAsyncParam<R, P>` | Use case assíncrono com parâmetro |
| `BaseUseCaseParam` | Classe abstrata base para parâmetros (estende `ParserToJson`) |
| `BaseCrudUseCase<R>` | Use case CRUD com `create`, `delete`, `list`, `read`, `update` |

#### **Autenticação e Usuário**

| Use Case | Descrição |
|----------|-----------|
| `LoginUseCase` | `call({username, password})` → `UserEntity` |
| `LogoutUseCase` | `call()` → `void` |
| `GetUserLocalDataUseCase` | `call()` → `UserEntity` (dados locais) |
| `GetUserRemoteDataUseCase` | `call()` → `UserEntity` (dados remotos) |
| `UpdateUserDataUseCase` | Atualizar dados do usuário |
| `UserAuthStorageUseCase` | Armazenamento de credenciais de auth |
| `EncryptUserPasswordUseCase` | Criptografar/descriptografar senha do usuário |
| `GetOtpCodeUseCase` | Obter código OTP |

#### **Notificações**

| Use Case | Descrição |
|----------|-----------|
| `CountUnreadNotificationsUseCase` | Contar notificações não lidas |
| `CreateNotificationUseCase` | Criar nova notificação |
| `TestPushNotificationUseCase` | Testar push notification |

#### **Dispositivo e Sistema**

| Use Case | Descrição |
|----------|-----------|
| `GetDeviceInfoUseCase` | `call()` → `DeviceInfoEntity` |
| `GetAppInfoUseCase` | `call()` → `AppInfoEntity` |
| `GetCurrentLocaleUseCase` | Obter locale atual |
| `GetDeviceLocaleUseCase` | Obter locale do dispositivo |
| `UpdateLocaleUseCase` | Atualizar locale da aplicação |
| `UpdateUserLocaleUseCase` | Atualizar locale do usuário |
| `ChangeNativeLocaleUseCase` | Mudar locale nativo do dispositivo |
| `GetIpAddressLocationUseCase` | Obter geolocalização via IP |
| `CheckInternetConnectionUseCase` | Verificar conexão com internet |

#### **Armazenamento e Segurança**

| Use Case | Descrição |
|----------|-----------|
| `LocalStorageUseCase` | `get`, `set`, `delete`, `clearAll`, `getKeys` |
| `SecureStorageUseCase` | Armazenamento seguro: `get`, `set`, `delete`, `clearAll` |
| `CacheStorageUseCase` | Cache storage: `load`, `save` |
| `FileStorageUseCase` | Armazenamento de arquivos |
| `SecurityEncryptUseCase` | Criptografia/descriptografia (senha/dados) |
| `RsaEncryptUseCase` | Criptografia RSA |
| `EncryptServerPublicKeyUseCase` | Criptografar chave pública do servidor |
| `IsolateUseCase` | Execução de tarefas em isolate separado |
| `PerformanceMetricUseCase` | Coleta de métricas de performance |

#### **Instalação**

| Use Case | Descrição |
|----------|-----------|
| `GetInstallationAppUseCase` | Obter dados da instalação |
| `UploadInstallationAppUseCase` | Upload de nova instalação |
| `ListUserInstallationsUseCase` | Listar instalações do usuário |

#### **Permissões e Compartilhamento**

| Use Case | Descrição |
|----------|-----------|
| `CheckPermissionUseCase` | Verificar permissão |
| `RequestPermissionUseCase` | Solicitar permissão |
| `ShareUseCase` | `call({title, subject, text, uri, files})` → `ShareResultEntity` |
| `ClipboardUseCase` | Operações com área de transferência |

#### **Navegação e URLs**

| Use Case | Descrição |
|----------|-----------|
| `OpenAppUseCase` | `call(url)` → `void` |
| `OpenWebUrlUseCase` | Abrir URL web |

---

### 📋 DTOs (Data Transfer Objects)

| DTO | Descrição |
|-----|-----------|
| `TestPushNotificationDto` | Estende `BaseUseCaseParam`. Campos: title, body, imageUrl |

---

### 🔧 Module Bindings (Injeção de Dependências)

| Classe | Descrição |
|--------|-----------|
| `DomainModuleBindings` | Implementa `ModuleBinding`. Injeta `AppEnvironmentEntity`, `SecurityEnvironmentEntity`, `ServerEnvironmentEntity`, `WebAppEnvironmentEntity` via `AppBinding.put()` usando `String.fromEnvironment` |

---

## Exemplos de Uso

### Exemplo 1: Login com Use Case

```dart
final loginUseCase = AppBinding.find<LoginUseCase>();

try {
  final user = await loginUseCase.call(
    username: 'user@example.com',
    password: 'password123',
  );
  print('Bem-vindo, ${user.name}!');
} catch (e) {
  // tratar erro de autenticação
}
```

### Exemplo 2: Buscar Dados do Usuário (Local)

```dart
final getUserDataUseCase = AppBinding.find<GetUserLocalDataUseCase>();

final user = await getUserDataUseCase.call();
print('Usuário: ${user.name}, Email: ${user.email}');
```

### Exemplo 3: Contar Notificações Não Lidas

```dart
final countUnreadUseCase = AppBinding.find<CountUnreadNotificationsUseCase>();

final count = await countUnreadUseCase.call();
print('Notificações não lidas: $count');
```

### Exemplo 4: Atualizar Dados do Usuário

```dart
final updateUserUseCase = AppBinding.find<UpdateUserDataUseCase>();

await updateUserUseCase.call(
  name: 'Novo Nome',
  email: 'novo@email.com',
);
```

### Exemplo 5: Logout

```dart
final logoutUseCase = AppBinding.find<LogoutUseCase>();

await logoutUseCase.call();
// usuário deslogado
```

### Exemplo 6: Verificar Conexão com Internet

```dart
final checkInternetUseCase = AppBinding.find<CheckInternetConnectionUseCase>();

final hasInternet = await checkInternetUseCase.call();
if (hasInternet) {
  print('Conectado à internet');
} else {
  print('Sem conexão');
}
```

### Exemplo 7: Compartilhar Conteúdo

```dart
final shareUseCase = AppBinding.find<ShareUseCase>();

final result = await shareUseCase.call(
  title: 'Confira isso!',
  text: 'Olha só este link interessante',
  uri: 'https://example.com',
);
print('Compartilhado: ${result.status}');
```

### Exemplo 8: Armazenamento Seguro

```dart
final secureStorageUseCase = AppBinding.find<SecureStorageUseCase>();

// Salvar
await secureStorageUseCase.set('token', 'abc123');

// Recuperar
final token = await secureStorageUseCase.get('token');

// Deletar
await secureStorageUseCase.delete('token');
```

### Exemplo 9: Armazenamento Local

```dart
final localStorageUseCase = AppBinding.find<LocalStorageUseCase>();

// Salvar
await localStorageUseCase.set('key', 'value');

// Recuperar
final value = await localStorageUseCase.get('key');

// Deletar
await localStorageUseCase.delete('key');
```

### Exemplo 10: Obter Informações do Dispositivo

```dart
final getDeviceInfoUseCase = AppBinding.find<GetDeviceInfoUseCase>();

final deviceInfo = await getDeviceInfoUseCase.call();
print('Dispositivo: ${deviceInfo.brand} ${deviceInfo.model}');
print('OS: ${deviceInfo.osName} ${deviceInfo.osVersion}');
```

---

## Estrutura de Pastas

```
packages/clean_code_domain/
├── lib/
│   ├── clean_code_domain.dart          # Barrel file principal
│   └── src/
│       ├── module_bindings.dart         # Injeção de dependências
│       ├── parsers/                     # Serialização
│       │   └── parser_to_json.dart
│       ├── entities/                    # Entidades de domínio
│       │   ├── base_entity.dart
│       │   ├── user_entity.dart
│       │   ├── session_entity.dart
│       │   ├── installation_entity.dart
│       │   ├── notification_entity.dart
│       │   ├── push_notification_entity.dart
│       │   ├── device_info_entity.dart
│       │   ├── app_info_entity.dart
│       │   ├── ip_address_location_entity.dart
│       │   ├── share_result_entity.dart
│       │   ├── app_environment_entity.dart
│       │   ├── security_environment_entity.dart
│       │   ├── server_environment_entity.dart
│       │   └── web_app_environment_entity.dart
│       ├── enums/                       # Enumerações
│       │   └── user_permissions_enum.dart
│       ├── dto/                         # Data Transfer Objects
│       │   └── test_push_notification_dto.dart
│       ├── repositories/                # Contratos de repositórios
│       │   └── base_repository.dart
│       ├── services/                    # Contratos de serviços
│       │   ├── base_crud_service.dart
│       │   ├── user_service.dart
│       │   ├── login_service.dart
│       │   ├── logout_service.dart
│       │   ├── notification_service.dart
│       │   ├── app_info_service.dart
│       │   └── ... (23 serviços no total)
│       └── use_cases/                   # Contratos de casos de uso
│           ├── base_use_case.dart
│           ├── login_use_case.dart
│           ├── logout_use_case.dart
│           ├── get_user_local_data_use_case.dart
│           └── ... (38 use cases no total)
└── test/                                # Testes
```

---

## Padrões de Nomenclatura

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Entities | Sufixo `Entity` | `UserEntity`, `NotificationEntity` |
| Services | Sufixo `Service` | `UserService`, `LoginService` |
| Use Cases | Sufixo `UseCase` | `LoginUseCase`, `GetUserLocalDataUseCase` |
| Repositories | Sufixo `Repository` | `BaseRepository` |
| DTOs | Sufixo `Dto` | `TestPushNotificationDto` |
| Enums | Sufixo `Enum` | `UserPermissionsEnum` |
| Params | Estende `BaseUseCaseParam` | `TestPushNotificationDto` |

---

## Herança e Mixins

| Classe Base | Estendida por | Descrição |
|-------------|--------------|-----------|
| `ParserToJson` | Entities, DTOs | Serialização `toMap()` |
| `BaseEntity` | Entities com DB | Adiciona `objectId`, `createdAt`, `updatedAt` |
| `BaseUseCaseParam` | DTOs | Parâmetros de use cases |
| `BaseCrudService<T>` | Serviços CRUD | Implementa interfaces de CRUD |

---

## Camadas e Fluxo de Dados

```
┌─────────────────────────────────────────────────────┐
│                   DOMAIN LAYER                       │
│  ┌──────────┐  ┌───────────┐  ┌────────────────┐  │
│  │ Entities │  │ Use Cases │  │  Repositories  │  │
│  │ (Regras) │  │ (Casos de │  │   (Contratos)  │  │
│  │ (Negócio)│  │  Uso)     │  │                │  │
│  └──────────┘  └───────────┘  └────────────────┘  │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │              Services (Contratos)            │   │
│  └─────────────────────────────────────────────┘   │
└──────────────────────┬──────────────────────────────┘
                       │ implements
┌──────────────────────▼──────────────────────────────┐
│                   DATA LAYER                         │
│  (Implementações: clean_code_data, clean_code_infra) │
└─────────────────────────────────────────────────────┘
```

---

## Injeção de Dependências

O `DomainModuleBindings` injeta as entidades de ambiente usando variáveis de compilação:

```dart
void initDomain() {
  DomainModuleBindings().dependencies();
}
```

As entidades são lidas via `String.fromEnvironment()`:
- `SERVER_URL`
- `APP_ID`
- `CLIENT_KEY`
- `REST_API_KEY`
- `ANALYTICS_APTABASE_APP_KEY`
- `SERVER_RSA_PUBLIC_KEY_BASE64`
- E outros...

---

## Dependências

- `flutter/material.dart`
- Pacotes internos: `core`, `dependency`

---

## Observações Importantes

1. **Regras de Negócio**: Este pacote contém apenas abstrações e regras de negócio puras, sem dependências externas de frameworks ou bibliotecas de UI.

2. **Entidades com ParserToJson**: Entidades que estendem `ParserToJson` podem ser serializadas para Map/JSON para comunicação entre camadas.

3. **Entidades com BaseEntity**: A classe abstrata `BaseEntity` estende `ParserToJson` e adiciona campos `objectId`, `createdAt`, `updatedAt` para entidades que requerem persistência.

4. **Use Cases**: Seguem o padrão de chamada `.call()` e podem ser síncronos ou assíncronos.

6. **Injeção de Dependências**: Use sempre `AppBinding.find<T>()` para obter as instâncias registradas via `DomainModuleBindings`.

---

## Licença

Consulte o arquivo LICENSE na raiz do projeto.
