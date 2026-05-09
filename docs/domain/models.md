# Model Documentation - clean_code_data

## Visão Geral

Os models no projeto `clean_code_data` são classes que estendem as entities do domínio (`clean_code_domain`) e adicionam a capacidade de desserialização a partir de dados JSON/Map. Eles atuam como a camada de dados entre as APIs/banco de dados e as entidades de domínio.

## Regras Gerais

1. **Nomenclatura**: Sempre usar o sufixo `Model` (ex: `UserModel`, `InstallationModel`)
2. **Herança**: Todo model deve estender sua correspondente `Entity` do domínio
3. **Construtor**: Usar construtor nomeado com `super` parameters (`required super.field`)
4. **Factory fromMap**: Todo model que recebe dados externos deve implementar `factory ClassName.fromMap(Map<String, dynamic> map)`
5. **Tratamento de erros**: Usar `try/catch` com `BaseException` no `fromMap`
6. **Complemento de erro**: Incluir `complement: 'Json Data: $map'` para debugging

---

## Cenário 1: Model Simples (Mapeamento Direto)

Model com mapeamento direto de campos do JSON para a entity.

```dart
import 'package:core/core.dart';

class InstallationModel extends InstallationEntity {
  InstallationModel({
    required super.installationId,
    required super.appName,
    required super.appVersion,
    required super.appIdentifier,
    required super.channels,
    required super.gcmSenderId,
    required super.deviceToken,
    required super.pushType,
    required super.deviceId,
    required super.deviceBrand,
    required super.deviceModel,
    required super.deviceType,
    required super.deviceOsVersion,
    required super.timeZone,
    required super.localeIdentifier,
    required super.platform,
    required super.ip,
  });

  factory InstallationModel.fromMap(Map<String, dynamic> map) {
    try {
      return InstallationModel(
        installationId: map['installationId'],
        appName: map['appName'],
        appVersion: map['appVersion'],
        appIdentifier: map['appIdentifier'],
        channels: List.from(map['channels'] ?? []),
        gcmSenderId: map['GCMSenderId'],
        deviceToken: map['deviceToken'],
        pushType: map['pushType'],
        deviceId: map['deviceId'],
        deviceBrand: map['deviceBrand'],
        deviceModel: map['deviceModel'],
        deviceType: map['deviceType'],
        deviceOsVersion: map['deviceOsVersion'],
        timeZone: map['timeZone'],
        localeIdentifier: map['localeIdentifier'],
        platform: map['platform'],
        ip: map['ip'],
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stackTrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
```

**Quando usar**: Quando os campos do JSON correspondem diretamente aos campos da entity.

---

## Cenário 2: Model com Nomes de Campos Diferentes (API Mapping)

Model onde os campos do JSON têm nomes diferentes dos campos da entity.

```dart
import 'package:core/core.dart';

class IpAddressLocationModel extends IpAddressLocationEntity {
  IpAddressLocationModel({
    required super.country,
    required super.countryCode,
    required super.region,
    required super.regionName,
    required super.city,
    required super.zip,
    required super.latitude,
    required super.longitude,
    required super.timezone,
    required super.isp,
    required super.org,
    required super.ispOrg,
    required super.ip,
  });

  factory IpAddressLocationModel.fromMap(Map<String, dynamic> map) {
    try {
      return IpAddressLocationModel(
        country: map['country'],
        countryCode: map['countryCode'],
        region: map['region'],
        regionName: map['regionName'],
        city: map['city'],
        zip: map['zip'],
        latitude: map['lat'],          // JSON: 'lat' -> Entity: 'latitude'
        longitude: map['lon'],         // JSON: 'lon' -> Entity: 'longitude'
        timezone: map['timezone'],
        isp: map['isp'],
        org: map['org'],
        ispOrg: map['as'],             // JSON: 'as' -> Entity: 'ispOrg'
        ip: map['query'],              // JSON: 'query' -> Entity: 'ip'
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stackTrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
```

**Quando usar**: Quando a API retorna campos com nomes diferentes do domínio (ex: APIs de terceiros).

---

## Cenário 3: Model com Valores Default

Model que fornece valores padrão para campos nulos no JSON.

```dart
import 'package:core/core.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.objectId,
    required super.title,
    required super.body,
    required super.viewed,
    required super.imageUrl,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    try {
      return NotificationModel(
        objectId: map['objectId'] ?? '',
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        viewed: map['viewed'] ?? false,
        imageUrl: map['imageUrl'] as String?,
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stackTrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
```

**Quando usar**: Quando a API pode retornar campos nulos que precisam de fallback para valores padrão.

---

## Cenário 4: Model com Lógica de Transformação

Model que aplica lógica complexa durante o mapeamento (cálculos, geração de URLs, fallback de campos).

```dart
import 'package:core/core.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.username,
    required super.name,
    required super.email,
    required super.avatarUrl,
    required super.createdAt,
    required super.updatedAt,
    required super.permissions,
    required super.locale,
    required super.sessionToken,
    required super.pushTopics,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      final String? name = map['name'] ?? map['nome'];
      final String firstName = (name ?? '').split(' ').first;
      final String avatarUrl =
          'https://ui-avatars.com/api/?format=png&name=$firstName';

      return UserModel(
        id: map['objectId'] ?? map['id'],
        username: map['username'] ?? map['email'],
        name: map['name'] ?? map['nome'],
        email: map['email'] ?? map['username'],
        avatarUrl: map['avatarUrl'] ?? avatarUrl,
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
        permissions: List.from(map['permissions'] ?? []).map((permission) {
          return UserPermissionsEnum.values.firstWhere((item) {
            final String permissionFormatted = permission
                .toString()
                .split('-')
                .first;
            final String userPermission = permissionFormatted.toLowerCase();
            final String enumPermission = item.name.toLowerCase();
            return userPermission == enumPermission;
          }, orElse: () => UserPermissionsEnum.USER);
        }).toList(),
        locale: map['locale'],
        sessionToken: map['sessionToken'] ?? map['token'],
        pushTopics: List.from(map['pushTopics'] ?? []),
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stackTrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
```

**Quando usar**: Quando o mapeamento requer:

- Fallback entre múltiplos campos (`map['name'] ?? map['nome']`)
- Geração de valores derivados (URLs de avatar)
- Conversão de enums complexos
- Transformação de listas

---

## Cenário 5: Model com Parse de DateTime

Model que converte strings de data/t hora para objetos `DateTime`.

```dart
import 'package:core/core.dart';

class WebVisitHistoryModel extends WebVisitHistoryEntity {
  WebVisitHistoryModel({
    required super.objectId,
    required super.website,
    required super.ip,
    required super.userAgent,
    required super.country,
    required super.countryCode,
    required super.countryFlag,
    required super.region,
    required super.regionName,
    required super.city,
    required super.zip,
    required super.lat,
    required super.lon,
    required super.timezone,
    required super.isp,
    required super.org,
    required super.ispOrg,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WebVisitHistoryModel.fromMap(Map<String, dynamic> map) {
    try {
      return WebVisitHistoryModel(
        objectId: map['objectId'] ?? '',
        website: map['website'] ?? '',
        ip: map['ip'] ?? '',
        userAgent: map['userAgent'] as String?,
        country: map['country'] as String?,
        countryCode: map['countryCode'] as String?,
        countryFlag: map['countryFlag'] as String?,
        region: map['region'] as String?,
        regionName: map['regionName'] as String?,
        city: map['city'] as String?,
        zip: map['zip'] as String?,
        lat: map['lat'] as double?,
        lon: map['lon'] as double?,
        timezone: map['timezone'] as String?,
        isp: map['isp'] as String?,
        org: map['org'] as String?,
        ispOrg: map['as'] as String?,
        createdAt: map['createdAt'] == null
            ? null
            : DateTime.tryParse(map['createdAt']).toLocal(),
        updatedAt: map['updatedAt'] == null
            ? null
            : DateTime.tryParse(map['updatedAt']).toLocal(),
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stackTrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
```

**Quando usar**: Quando a entity possui campos `DateTime` e a API retorna strings ISO 8601.

---

## Checklist para Criar um Novo Model

- [ ] Nome da classe segue o padrão `NomeModel`
- [ ] Estende a `Entity` correspondente do domínio
- [ ] Construtor usa `super.field` para todos os parâmetros
- [ ] Implementa `factory ClassName.fromMap(Map<String, dynamic> map)`
- [ ] Usa `try/catch` com `BaseException` para tratamento de erros
- [ ] Inclui `complement: 'Json Data: $map'` no erro
- [ ] Usa `??` para valores default quando campos podem ser nulos
- [ ] Usa `as Type?` para casts explícitos de tipos nullable
- [ ] Converte `DateTime` com `DateTime.parse().toLocal()` quando aplicável
- [ ] Usa `List.from(map['field'] ?? [])` para listas
- [ ] Ordena os campos no `fromMap` na mesma ordem do construtor

---

## Padrões de Mapeamento Comuns

| Tipo               | Padrão                                                        | Exemplo                                      |
| ------------------ | ------------------------------------------------------------- | -------------------------------------------- |
| String obrigatório | `map['field'] ?? ''`                                          | `title: map['title'] ?? ''`                  |
| String nullable    | `map['field'] as String?`                                     | `imageUrl: map['imageUrl'] as String?`       |
| Bool com default   | `map['field'] ?? false`                                       | `viewed: map['viewed'] ?? false`             |
| Lista              | `List.from(map['field'] ?? [])`                               | `channels: List.from(map['channels'] ?? [])` |
| Double nullable    | `map['field'] as double?`                                     | `lat: map['lat'] as double?`                 |
| DateTime           | `map['field'] == null ? null : DateTime.parse(...).toLocal()` | `createdAt: ...`                             |
| Fallback de campo  | `map['field1'] ?? map['field2']`                              | `id: map['objectId'] ?? map['id']`           |
| Enum com fallback  | `Enum.values.firstWhere(..., orElse: () => Enum.DEFAULT)`     | `permissions: ...`                           |

---

## Hierarquia de Classes

```
Entity (clean_code_domain)
  └── Model (clean_code_data)
        ├── InstallationModel
        ├── IpAddressLocationModel
        ├── NotificationModel
        ├── PushNotificationModel
        ├── UserModel
        └── WebVisitHistoryModel
```

---

## Relação Entity ↔ Model

| Entity                    | Model                    |
| ------------------------- | ------------------------ |
| `InstallationEntity`      | `InstallationModel`      |
| `IpAddressLocationEntity` | `IpAddressLocationModel` |
| `NotificationEntity`      | `NotificationModel`      |
| `PushNotificationEntity`  | `PushNotificationModel`  |
| `UserEntity`              | `UserModel`              |
| `WebVisitHistoryEntity`   | `WebVisitHistoryModel`   |

---

## Boas Práticas

1. **Não adicionar lógica de negócio** nos models - eles devem ser apenas mapeadores de dados
2. **Manter o fromMap puro** - apenas mapeamento, sem efeitos colaterais
3. **Usar valores default** para campos opcionais da API
4. **Documentar diferenças de nomenclatura** entre API e domínio com comentários
5. **Sempre usar try/catch** no fromMap para capturar erros de parsing
6. **Incluir dados do map no erro** para facilitar debugging
