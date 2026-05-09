# Clean Code Infra Package

Camada de infraestrutura seguindo os princípios de **Clean Architecture**. Fornece implementações concretas para acesso a dados remotos (API), armazenamento local (Hive/SharedPreferences) e comunicação HTTP.

## Instalação

No `pubspec.yaml` do app principal ou pacote que consumirá a infraestrutura:

```yaml
dependencies:
  clean_code_infra:
    path: packages/clean_code_infra
```

## Importação

```dart
import 'package:clean_code_infra/clean_code_infra.dart';
```

---

## Índice de Componentes

### 🗄 Database (Banco de Dados Local)

Implementações de persistência local usando Hive.

| Componente | Descrição |
|------------|-----------|
| `HiveLocalDatabase<T>` | Implementação de `LocalDatabase<T>` usando Hive. Gerencia operações CRUD básicas com armazenamento local. |
| `HiveOfflineFirstLocalDatabase<T>` | Implementação de `OfflineFirstLocalDatabase<T>`. Estratégia offline-first com 3 bancos Hive: principal, offline (pendências) e deleted (itens removidos offline). |
| `DatabaseParserMixin` | Mixin com métodos `encodeValue<T>` e `decodeValue<T>` para serialização de tipos primitivos, List e Map para strings armazenáveis. |

---

### 🌐 HTTP (Comunicação HTTP)

Cliente HTTP para comunicação com APIs remotas.

| Componente | Descrição |
|------------|-----------|
| `HttpClientImpl` | Implementação de `HttpClient` usando Dio. Suporta GET, POST, PUT, DELETE e método genérico `request`. Tratamento de timeouts e parsing de respostas/erros HTTP. Integra com Sentry. |
| `LogInterceptor` | Interceptor do Dio para logging de requests, responses e erros. Registra via `Log` e envia erros para Crashlytics. |

---

### 💾 Local Storage (Armazenamento Local Chave-Valor)

Implementações para armazenamento local simples de pares chave-valor.

| Componente | Descrição |
|------------|-----------|
| `HiveLocalStorage` | Implementação de `LocalStorage` usando Hive (`HiveLocalDatabase`). Operações: get, set, delete, clearAll, getKeys. |
| `SharedPreferencesLocalStorageImpl` | Implementação de `LocalStorage` usando SharedPreferences. Suporta tipos: int, bool, double, String, List<String>, Map (via JSON). |

---

### 📡 Data Sources (Fontes de Dados Remotas)

Implementações concretas para acesso a APIs/serviços remotos.

| Componente | Interface | Mixins | Descrição |
|------------|-----------|--------|-----------|
| `LoginDataSourceImpl` | `LoginDataSource` | - | Autenticação de usuário (username/password). |
| `LogoutDataSourceImpl` | `LogoutDataSource` | - | Logout do usuário. |
| `UserDataSourceImpl` | `UserDataSource` | `ReadDtaSourceMixin`, `DeleteDataSourceMixin`, `UpdateDataSourceMixin` | Operações de usuário: buscar dados, atualizar, deletar conta, alterar senha. |
| `NotificationDataSourceImpl` | `NotificationDataSource` | `CreateDataSourceMixin`, `ListDataSourceMixin` | Gerenciamento de notificações: criar, listar, contar não lidas, marcar como lida, teste de push. Usa GraphQL para contagem. |
| `AppInstallationDataSourceImpl` | `AppInstallationDataSource` | `CreateDataSourceMixin`, `ListDataSourceMixin` | Operações de instalação do app (upload e listagem por usuário). |
| `IpAddressLocationDataSourceImpl` | `IpAddressLocationDataSource` | `ReadDtaSourceMixin` | Consulta localização geográfica via IP. |
| `WebVisitHistoryDataSourceImpl` | `WebVisitHistoryDataSource` | `ListDataSourceMixin` | Listagem de histórico de visitas web com paginação. |
| `RefreshTokenDataSourceImpl` | `RefreshTokenDataSource` | - | Refresh token (**não implementado** - lança `UnimplementedError`). |

---

### 🔧 Module Bindings (Injeção de Dependências)

| Componente | Descrição |
|------------|-----------|
| `InfraModuleBindings` | Implementa `ModuleBinding`. Registra todas as dependências no `AppBinding`: `LocalStorage`, `HttpClient`, e todos os Data Sources. Usa `permanent` para serviços centrais e `lazyPut` para data sources sob demanda. |

---

## Exemplos de Uso

### Exemplo 1: Configuração de Injeção de Dependências

No `AppBinding` ou classe de inicialização:

```dart
void initDependencies() {
  InfraModuleBindings().dependencies();
}
```

### Exemplo 2: Fazendo Login via Data Source

```dart
final loginDataSource = AppBinding.find<LoginDataSource>();

try {
  final user = await loginDataSource.login(
    username: 'user@example.com',
    password: 'password123',
  );
  // usuário autenticado
} catch (e) {
  // tratar erro de autenticação
}
```

### Exemplo 3: Buscar Dados do Usuário

```dart
final userDataSource = AppBinding.find<UserDataSource>();

final user = await userDataSource.read();
print('Usuário: ${user.name}');
```

### Exemplo 4: Listar Notificações

```dart
final notificationDataSource = AppBinding.find<NotificationDataSource>();

final notifications = await notificationDataSource.list(
  page: 1,
  limit: 20,
);

final unreadCount = await notificationDataSource.getUnreadCount();
```

### Exemplo 5: Usando HttpClient Direto

```dart
final httpClient = AppBinding.find<HttpClient>();

final response = await httpClient.get(
  url: '/api/endpoint',
  queryParameters: {'page': '1'},
);

if (response.isSuccess) {
  final data = response.data;
}
```

### Exemplo 6: Armazenamento Local com LocalStorage

```dart
final localStorage = AppBinding.find<LocalStorage>();

// Salvar dados
await localStorage.set('token', 'abc123');
await localStorage.set('user_id', 123);

// Recuperar dados
final token = await localStorage.get<String>('token');
final userId = await localStorage.get<int>('user_id');

// Deletar
await localStorage.delete('token');

// Limpar tudo
await localStorage.clearAll();
```

### Exemplo 7: Usando HiveLocalDatabase para Entities

```dart
// Exemplo com uma entity que estende ParserToJson
class UserEntity extends ParserToJson {
  final String id;
  final String name;

  UserEntity({required this.id, required this.name});

  factory UserEntity.fromMap(Map<String, dynamic> map) => ...;
  @override
  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}

// Inicializar banco
final userDatabase = HiveLocalDatabase<UserEntity>('user_box');

// Salvar
await userDatabase.create(user);

// Buscar todos
final users = await userDatabase.getAll();

// Buscar por ID
final user = await userDatabase.get('user_id');

// Atualizar
await userDatabase.update(user);

// Deletar
await userDatabase.delete('user_id');
```

### Exemplo 8: Estratégia Offline-First

```dart
final database = HiveOfflineFirstLocalDatabase<UserEntity>('user_offline');

// Criar item (salva localmente, sincroniza depois)
await database.create(userEntity);

// Listar itens pendentes de sincronização
final pendingItems = await database.getPendingSyncItems();

// Marcar como sincronizado
await database.markAsSynced(userEntity.id);

// Itens deletados offline
final deletedItems = await database.getDeletedItems();
```

### Exemplo 9: Atualizar Dados do Usuário

```dart
final userDataSource = AppBinding.find<UserDataSource>();

try {
  final updatedUser = await userDataSource.update(
    name: 'Novo Nome',
    email: 'novo@email.com',
  );
  print('Usuário atualizado: ${updatedUser.name}');
} catch (e) {
  // tratar erro
}
```

### Exemplo 10: Consultar Localização por IP

```dart
final ipLocationDataSource = AppBinding.find<IpAddressLocationDataSource>();

final location = await ipLocationDataSource.read();
print('Localização: ${location.city}, ${location.country}');
```

---

## Estrutura de Pastas

```
packages/clean_code_infra/
├── lib/
│   ├── clean_code_infra.dart          # Barrel file principal
│   └── src/
│       ├── module_bindings.dart        # Injeção de dependências
│       ├── database/                   # Camada de banco de dados local
│       │   ├── hive_local_database.dart
│       │   ├── hive_offline_first_local_database.dart
│       │   └── mixin/
│       │       └── database_parser_mixin.dart
│       ├── data_sources/               # Fontes de dados (API remote)
│       │   ├── login_data_source.dart
│       │   ├── logout_data_source.dart
│       │   ├── user_data_source.dart
│       │   ├── notification_data_source.dart
│       │   ├── app_installation_data_source.dart
│       │   ├── ip_address_location_data_source.dart
│       │   ├── web_visit_history_data_source.dart
│       │   └── refresh_token_data_source.dart
│       ├── http/                       # Camada HTTP
│       │   ├── http_client.dart
│       │   └── interceptors/
│       │       └── log_interceptor.dart
│       └── local_storage/              # Armazenamento local
│           ├── hive_local_storage.dart
│           └── shared_preferences_local_storage.dart
└── test/                               # Testes
```

---

## Padrões de Data Sources

A maioria dos Data Sources utiliza Mixins do `clean_code_data` para reduzir boilerplate:

| Mixin | Descrição |
|-------|-----------|
| `CreateDataSourceMixin` | Adiciona método `create` padrão |
| `ListDataSourceMixin` | Adiciona método `list` padrão com paginação |
| `ReadDtaSourceMixin` | Adiciona método `read` padrão |
| `UpdateDataSourceMixin` | Adiciona método `update` padrão |
| `DeleteDataSourceMixin` | Adiciona método `delete` padrão |

Exemplo de uso de Mixin:

```dart
class UserDataSourceImpl with ReadDtaSourceMixin, UpdateDataSourceMixin implements UserDataSource {
  // Os métodos read, update já estão disponíveis via Mixin
  // Basta implementar os detalhes específicos se necessário
}
```

---

## Dependências

- `flutter/material.dart`
- `dio` (Cliente HTTP)
- `hive` / `hive_flutter` (Banco de dados local)
- `shared_preferences` (Armazenamento chave-valor)
- Pacotes internos: `core`, `dependency`, `clean_code_data`, `clean_code_domain`

---

## Camadas e Fluxo de Dados

```
┌─────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                    │
│  (Interfaces: UserDataSource, LoginDataSource...)   │
└──────────────────────┬──────────────────────────────┘
                       │ implements
┌──────────────────────▼──────────────────────────────┐
│                   INFRA LAYER                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ │
│  │ Data Sources │  │ HTTP Client  │  │ Database │ │
│  └──────────────┘  └──────────────┘  └──────────┘ │
└──────────────────────┬──────────────────────────────┘
                       │ calls
┌──────────────────────▼──────────────────────────────┐
│                   EXTERNAL API                      │
│   (REST/GraphQL Endpoints, Hive DB, SharedPreferences)│
└─────────────────────────────────────────────────────┘
```

---

## Observações Importantes

1. **Refresh Token**: O `RefreshTokenDataSourceImpl` ainda não foi implementado (`throws UnimplementedError()`).

2. **Offline-First**: O `HiveOfflineFirstLocalDatabase` implementa uma estratégia onde dados podem ser salvos offline e sincronizados posteriormente.

3. **Testes**: Existem arquivos de teste para quase todos os componentes principais na pasta `test/`.

4. **Injeção de Dependências**: Sempre use `InfraModuleBindings` para registrar as dependências no `AppBinding` antes de usar os data sources.

5. **Tratamento de Erros**: O `HttpClientImpl` integra automaticamente com Sentry para reporting de erros.

---

## Licença

Consulte o arquivo LICENSE na raiz do projeto.
