# Domain Use-Cases

Propósito
- Contratos de casos de uso no domínio: entrada/saída, regras de negócio.

## Visão Geral

Use cases no `clean_code_domain` definem contratos abstratos para operações da aplicação. Cada use case encapsula uma regra de negócio específica e é implementado na camada `clean_code_data`.

## Padrão de Nomenclatura

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Use Case | Sufixo `UseCase` | `LoginUseCase`, `GetUserLocalDataUseCase` |
| Param | Sufixo `Param` ou `Dto` | `TestPushNotificationDto` |
| Base Use Case | `BaseUseCase*` | `BaseUseCaseAsync<R>`, `BaseUseCaseSyncParam<R, P>` |

## Hierarquia de Use Cases

```
BaseUseCaseSync<R>        → Use case síncrono sem parâmetros
BaseUseCaseSyncParam<R,P> → Use case síncrono com parâmetro
BaseUseCaseAsync<R>       → Use case assíncrono sem parâmetros
BaseUseCaseAsyncParam<R,P>→ Use case assíncrono com parâmetro
BaseCrudUseCase<R>        → Use case CRUD (create, read, update, delete, list)
```

## Exemplos de Use Cases

### Autenticação e Usuário

| Use Case | Entrada | Saída | Descrição |
|----------|---------|-------|-----------|
| `LoginUseCase` | `{username, password}` | `UserEntity` | Autenticar usuário |
| `LogoutUseCase` | `{}` | `void` | Encerrar sessão |
| `GetUserLocalDataUseCase` | `{}` | `UserEntity` | Dados do usuário (local) |
| `GetUserRemoteDataUseCase` | `{}` | `UserEntity` | Dados do usuário (remoto) |
| `UpdateUserDataUseCase` | `{name, email}` | `void` | Atualizar dados |
| `UserAuthStorageUseCase` | `{token}` | `void` | Armazenar credenciais |
| `EncryptUserPasswordUseCase` | `{password}` | `String` | Criptografar senha |
| `GetOtpCodeUseCase` | `{}` | `String` | Obter código OTP |

### Notificações

| Use Case | Entrada | Saída | Descrição |
|----------|---------|-------|-----------|
| `CountUnreadNotificationsUseCase` | `{}` | `int` | Contar não lidas |
| `CreateNotificationUseCase` | `{notification}` | `void` | Criar notificação |
| `TestPushNotificationUseCase` | `{title, body, imageUrl}` | `void` | Testar push |

### Dispositivo e Sistema

| Use Case | Entrada | Saída | Descrição |
|----------|---------|-------|-----------|
| `GetDeviceInfoUseCase` | `{}` | `DeviceInfoEntity` | Info do dispositivo |
| `GetAppInfoUseCase` | `{}` | `AppInfoEntity` | Info do app |
| `GetCurrentLocaleUseCase` | `{}` | `Locale` | Locale atual |
| `GetDeviceLocaleUseCase` | `{}` | `Locale` | Locale do dispositivo |
| `UpdateLocaleUseCase` | `{locale}` | `void` | Atualizar locale |
| `UpdateUserLocaleUseCase` | `{locale}` | `void` | Atualizar locale do usuário |
| `ChangeNativeLocaleUseCase` | `{locale}` | `void` | Mudar locale nativo |
| `GetIpAddressLocationUseCase` | `{ip}` | `IpAddressLocationEntity` | Geolocalização via IP |
| `CheckInternetConnectionUseCase` | `{}` | `bool` | Verificar internet |

### Armazenamento e Segurança

| Use Case | Entrada | Saída | Descrição |
|----------|---------|-------|-----------|
| `LocalStorageUseCase` | `{key, value}` | `dynamic` | get/set/delete |
| `SecureStorageUseCase` | `{key, value}` | `dynamic` | Armazenamento seguro |
| `CacheStorageUseCase` | `{key}` | `dynamic` | Cache |
| `FileStorageUseCase` | `{path}` | `File` | Armazenamento de arquivos |
| `SecurityEncryptUseCase` | `{data}` | `String` | Criptografar dados |
| `RsaEncryptUseCase` | `{data}` | `String` | Criptografia RSA |
| `EncryptServerPublicKeyUseCase` | `{key}` | `String` | Criptografar chave pública |

### Instalação

| Use Case | Entrada | Saída | Descrição |
|----------|---------|-------|-----------|
| `GetInstallationAppUseCase` | `{}` | `InstallationEntity` | Dados da instalação |
| `UploadInstallationAppUseCase` | `{installation}` | `void` | Upload de instalação |
| `ListUserInstallationsUseCase` | `{}` | `List<InstallationEntity>` | Listar instalações |

### Permissões e Compartilhamento

| Use Case | Entrada | Saída | Descrição |
|----------|---------|-------|-----------|
| `CheckPermissionUseCase` | `{permission}` | `bool` | Verificar permissão |
| `RequestPermissionUseCase` | `{permission}` | `bool` | Solicitar permissão |
| `ShareUseCase` | `{title, text, uri}` | `ShareResultEntity` | Compartilhar conteúdo |
| `ClipboardUseCase` | `{text}` | `void` | Área de transferência |

### Navegação e URLs

| Use Case | Entrada | Saída | Descrição |
|----------|---------|-------|-----------|
| `OpenAppUseCase` | `{url}` | `void` | Abrir app externo |
| `OpenWebUrlUseCase` | `{url}` | `void` | Abrir URL no navegador |

## Como Criar um Novo Use Case

### 1. Definir o contrato no domain

```dart
// packages/clean_code_domain/lib/src/use_cases/my_new_use_case.dart

abstract class MyNewUseCase {
  Future<MyEntity> call({required String param});
}
```

### 2. Implementar no data

```dart
// packages/clean_code_data/lib/src/use_cases/my_new_use_case_impl.dart

class MyNewUseCaseImpl implements MyNewUseCase {
  final MyRepository _repository;

  MyNewUseCaseImpl({required MyRepository repository}) 
    : _repository = repository;

  @override
  Future<MyEntity> call({required String param}) async {
    return _repository.fetch(param: param);
  }
}
```

### 3. Registrar na binding

```dart
AppBinding.put<MyNewUseCase>(
  MyNewUseCaseImpl(repository: AppBinding.find<MyRepository>()),
);
```

## Checklist para Criar um Novo Use Case

- [ ] Nome segue padrão `NomeDoUseCase`
- [ ] Contrato abstrato definido em `clean_code_domain`
- [ ] Implementação em `clean_code_data` com sufixo `Impl`
- [ ] Tratamento de erros adequado
- [ ] Registrado via `AppBinding.put()`
- [ ] Testes unitários para cenários de sucesso e erro

---

**Ver também**: [Entities](entities.md) | [Models](../data/models.md) | [Glossário](../glossary.md)
