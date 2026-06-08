# Data Services

## Visão Geral

Os services em `clean_code_data` implementam os contratos definidos em `clean_code_domain`. Eles coordenam o acesso a data sources (API, armazenamento local) e retornam entidades de domínio para os use cases.

**Veja também**: [Domain Services](../domain/README.md#-services-contratos-de-serviços) | [Data Sources](../infra/infra.md#-data-sources-fontes-de-dados-remotas)

## Padrão de Nomenclatura

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Service (domain) | Sufixo `Service` | `UserService`, `LoginService` |
| Service (data) | Sufixo `Impl` | `UserServiceImpl`, `LoginServiceImpl` |

## Implementações

### Autenticação e Usuário

| Service | Domain Interface | Dependências |
|---------|-----------------|--------------|
| `LoginServiceImpl` | `LoginService` | `LoginDataSource`, `EncryptServerPublicKeyUseCase` |
| `LogoutServiceImpl` | `LogoutService` | `LogoutDataSource` |
| `UserServiceImpl` | `UserService` | `UserDataSource` |
| `UserAuthSecureStorageImpl` | `UserAuthStorageService` | `SecureStorageUseCase` |
| `UserAuthLocalStorageServiceImpl` | `UserAuthStorageService` | `LocalStorageUseCase` |

### Notificações

| Service | Domain Interface | Padrão |
|---------|-----------------|--------|
| `NotificationServiceImpl` | `NotificationService` | `CreateServiceMixin`, `ListServiceMixin` |

### Dispositivo e Sistema

| Service | Domain Interface | Dependências |
|---------|-----------------|--------------|
| `AppInfoServiceImpl` | `AppInfoService` | `package_info_plus` |
| `AppInstallationServiceImpl` | `AppInstallationService` | Múltiplos data sources/services |
| `AppLocaleServiceImpl` | `AppLocaleService` | `LocalStorageUseCase` |
| `AppPermissionsServiceImpl` | `AppPermissionsService` | `Permission` (permission_handler) |
| `DeviceInfoServiceImpl` | `DeviceInfoService` | `device_info_plus` |
| `InternetConnectionServiceImpl` | `InternetConnectionService` | Nativo (connectivity_plus) |
| `IpAddressLocationServiceImpl` | `IpAddressLocationService` | `IpAddressLocationDataSource` |
| `OpenUrlServiceImpl` | `OpenUrlService` | Nativo |

### Armazenamento e Segurança

| Service | Domain Interface | Dependências |
|---------|-----------------|--------------|
| `LocalStorageServiceImpl` | `LocalStorageService` | `LocalStorage` |
| `SecureStorageServiceImpl` | `SecureStorageService` | `flutter_secure_storage` |
| `CacheLocalStorageServiceImpl` | — | `LocalStorageUseCase` |
| `CacheFileStorageServiceImpl` | — | `FileStorageUseCase` |
| `FileStorageServiceImpl` | `FileStorageService` | Nativo |
| `SecurityEncryptServiceImpl` | `SecurityEncryptService` | Nativo |
| `RsaEncryptServiceImpl` | `RsaEncryptService` | Nativo |
| `OtpCodeServiceImpl` | `OtpCodeService` | Nativo |
| `ShareServiceImpl` | `ShareService` | Nativo |
| `ClipboardServiceImpl` | `ClipboardService` | Nativo |

## Padrões de Implementação

### Services com Mixins CRUD

Usam `CreateServiceMixin` e `ListServiceMixin` para reduzir boilerplate:

```dart
class NotificationServiceImpl
    with CreateServiceMixin<NotificationEntity>,
         ListServiceMixin<NotificationEntity>
    implements NotificationService {

  final NotificationDataSource _dataSource;

  NotificationServiceImpl({required NotificationDataSource dataSource})
    : _dataSource = dataSource;
}
```

### Services Diretos

Injetam data sources e fazem conversão `Model.fromMap()`:

```dart
class UserServiceImpl implements UserService {
  final UserDataSource _dataSource;

  UserServiceImpl({required UserDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<UserEntity> getUserData() async {
    final map = await _dataSource.read();
    return UserModel.fromMap(map);
  }
}
```

### Services Nativos

Envolvem plugins Flutter (device_info_plus, package_info_plus, etc.) sem dependência de data sources:

```dart
class DeviceInfoServiceImpl implements DeviceInfoService {
  @override
  Future<DeviceInfoEntity> getDeviceInfo() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    // mapear para DeviceInfoEntity
  }
}
```

## Tratamento de Erros

```dart
try {
  return UserModel.fromMap(await _dataSource.read());
} on HttpException catch (error, stackTrace) {
  throw ExceptionHelper.call(error, stackTrace: stackTrace);
} on BaseException catch (error) {
  Log.baseException(error);
  rethrow;
} catch (error, stackTrace) {
  Log.exception(error, stackTrace);
  throw BaseException(error: error, stackTrace: stackTrace);
}
```

## Registro na Binding

```dart
// Em DataModuleBindings
AppBinding.put<UserService>(
  UserServiceImpl(dataSource: AppBinding.find<UserDataSource>()),
);
```

---

**Ver também**: [Domain Services](../domain/README.md#-services-contratos-de-serviços) | [Models](models.md) | [Infra](../infra/infra.md)
