# Entity Documentation - clean_code_domain

## Visão Geral

As entidades no projeto `clean_code_domain` representam objetos de domínio imutáveis e seguem um padrão consistente. Todas as entidades possuem o sufixo `Entity` em seus nomes.

## Regras Gerais

1. **Nomenclatura**: Sempre usar o sufixo `Entity` (ex: `UserEntity`, `AppInfoEntity`)
2. **Imutabilidade**: Todos os campos devem ser `final`
3. **Construtor**: Usar construtor nomeado com parâmetros nomeados (`{}`)
4. **Campos obrigatórios**: Usar `required` para campos não-nulos
5. **Campos opcionais**: Usar tipo nullable (`Type?`) para campos que podem ser nulos
6. **ParserToJson**: Entidades que precisam de serialização devem estender `ParserToJson`
7. **BaseEntity**: Entidades persistidas em banco de dados devem estender `BaseEntity`

---

## Cenário 1: Entity Simples (DTO)

Entidades que apenas transportam dados sem necessidade de serialização.

```dart
class SecurityEnvironmentEntity {
  final String encryptKey;
  final String serverRSAPublicKeyBase64;

  SecurityEnvironmentEntity({
    required this.encryptKey,
    required this.serverRSAPublicKeyBase64,
  });
}
```

**Quando usar**: Dados de configuração, valores estáticos, ou entidades que não precisam ser serializadas para JSON.

---

## Cenário 2: Entity com Parâmetros Opcionais

Entidades com campos que podem ser nulos, sem usar `required`.

```dart
class ServerEnvironmentEntity {
  final String serverUrl;
  final String? appId;
  final String? clientKey;
  final String? restApiKey;
  final String? graphqlUrl;

  ServerEnvironmentEntity({
    required this.serverUrl,
    this.appId,
    this.clientKey,
    this.restApiKey,
    this.graphqlUrl,
  });
}
```

**Nota**: Campos obrigatórios usam `required this.field`, campos opcionais usam apenas `this.field`.

---

## Cenário 3: Entity com ParserToJson (Serialização)

Entidades que precisam ser convertidas para Map/JSON devem estender `ParserToJson`.

```dart
import 'package:clean_code_domain/src/parsers/parser_to_json.dart';

class DeviceInfoEntity extends ParserToJson {
  final String brand;
  final bool isPhysicalDevice;
  final String model;
  final String osVersion;
  final String? localeName;
  final String? deviceId;
  final String platform;

  DeviceInfoEntity({
    required this.brand,
    required this.isPhysicalDevice,
    required this.model,
    required this.osVersion,
    required this.localeName,
    required this.deviceId,
    required this.platform,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'isPhysicalDevice': isPhysicalDevice,
      'model': model,
      'osVersion': osVersion,
      'localeName': localeName,
      'deviceId': deviceId,
      'platform': platform,
    };
  }
}
```

**Quando usar**: Entidades que serão enviadas para APIs, salvas em storage, ou precisam de serialização.

**Nota**: `ParserToJson` já implementa `toString()` automaticamente, retornando `toMap().toString()`.

---

## Cenário 4: Entity com Getters Computados

Entidades que possuem propriedades derivadas dos seus campos.

```dart
import 'package:clean_code_domain/src/parsers/parser_to_json.dart';

class AppInfoEntity extends ParserToJson {
  final String appName;
  final String packageName;
  final String buildSignature;
  final String? installerStore;
  final String version;
  final String build;

  AppInfoEntity({
    required this.appName,
    required this.packageName,
    required this.buildSignature,
    required this.installerStore,
    required this.version,
    required this.build,
  });

  String get formattedName => '$version ($build)';

  String get versionOnly => version.split('-').first;

  @override
  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'packageName': packageName,
      'buildSignature': buildSignature,
      'installerStore': installerStore,
      'version': version,
      'build': build,
    };
  }
}
```

**Quando usar**: Quando a entidade precisa expor valores calculados a partir dos seus dados.

---

## Cenário 5: Entity com Factory Constructor

Entidades que possuem construtores factory para criar instâncias especiais.

```dart
class IpAddressLocationEntity {
  final String? country;
  final String? countryCode;
  final String? region;
  final String? regionName;
  final String? city;
  final String? zip;
  final double? latitude;
  final double? longitude;
  final String? timezone;
  final String? isp;
  final String? org;
  final String? ispOrg;
  final String? ip;

  IpAddressLocationEntity({
    required this.country,
    required this.countryCode,
    required this.region,
    required this.regionName,
    required this.city,
    required this.zip,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.isp,
    required this.org,
    required this.ispOrg,
    required this.ip,
  });

  factory IpAddressLocationEntity.emptyIpAddress() {
    return IpAddressLocationEntity(
      country: null,
      countryCode: null,
      region: null,
      regionName: null,
      city: null,
      zip: null,
      latitude: null,
      longitude: null,
      timezone: null,
      isp: null,
      org: null,
      ispOrg: null,
      ip: null,
    );
  }
}
```

**Quando usar**: Quando a entidade precisa de instâncias predefinidas (empty, default, mock, etc).

---

## Cenário 6: Entity com copyWith (Imutabilidade)

Entidades que suportam cópia com campos modificados.

```dart
import 'package:clean_code_domain/src/parsers/parser_to_json.dart';

class NotificationEntity extends ParserToJson {
  final String objectId;
  final String title;
  final String body;
  final bool viewed;
  final String? imageUrl;

  NotificationEntity({
    required this.objectId,
    required this.title,
    required this.body,
    required this.viewed,
    required this.imageUrl,
  });

  NotificationEntity copyWith({
    String? title,
    String? body,
    bool? viewed,
    String? imageUrl,
  }) {
    return NotificationEntity(
      objectId: objectId,
      title: title ?? this.title,
      body: body ?? this.body,
      viewed: viewed ?? this.viewed,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'title': title,
      'body': body,
      'viewed': viewed,
      'imageUrl': imageUrl,
    };
  }
}
```

**Quando usar**: Entidades que podem ser atualizadas parcialmente (ex: atualizar apenas o campo `viewed` de uma notificação).

---

## Cenário 7: Entity com equals Customizado

Entidades que possuem lógica de comparação personalizada.

```dart
import 'package:clean_code_domain/src/parsers/parser_to_json.dart';

class InstallationEntity extends ParserToJson {
  final String? installationId;
  final String appName;
  final String appVersion;
  final String appIdentifier;
  final List<String> channels;
  final String? gcmSenderId;
  final String? deviceToken;
  final String? pushType;
  final String? deviceId;
  final String deviceBrand;
  final String deviceModel;
  final String deviceType;
  final String deviceOsVersion;
  final String timeZone;
  final String? localeIdentifier;
  final String platform;
  final String? ip;

  InstallationEntity({
    required this.installationId,
    required this.appName,
    required this.appVersion,
    required this.appIdentifier,
    required this.channels,
    required this.gcmSenderId,
    required this.deviceToken,
    required this.pushType,
    required this.deviceId,
    required this.deviceBrand,
    required this.deviceModel,
    required this.deviceType,
    required this.deviceOsVersion,
    required this.timeZone,
    required this.localeIdentifier,
    required this.platform,
    required this.ip,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'installationId': installationId,
      'appName': appName,
      'appVersion': appVersion,
      'appIdentifier': appIdentifier,
      'channels': channels,
      'GCMSenderId': gcmSenderId,
      'deviceToken': deviceToken,
      'pushType': pushType,
      'deviceId': deviceId,
      'deviceBrand': deviceBrand,
      'deviceModel': deviceModel,
      'deviceType': deviceType,
      'deviceOsVersion': deviceOsVersion,
      'timeZone': timeZone,
      'localeIdentifier': localeIdentifier,
      'platform': platform,
      'ip': ip,
    };
  }

  bool equals(InstallationEntity other) {
    return installationId == other.installationId &&
        appVersion == other.appVersion &&
        gcmSenderId == other.gcmSenderId &&
        deviceToken == other.deviceToken &&
        pushType == other.pushType &&
        deviceId == other.deviceId &&
        deviceOsVersion == other.deviceOsVersion &&
        timeZone == other.timeZone &&
        localeIdentifier == other.localeIdentifier;
  }
}
```

**Quando usar**: Quando a comparação precisa ser baseada em campos específicos, ignorando outros (ex: comparar apenas campos identificadores, ignorando timestamps).

---

## Cenário 8: Entity com Processamento no Construtor

Entidades que processam dados no corpo do construtor.

```dart
class AppEnvironmentEntity {
  final String appName;
  final String androidPackageName;
  final String appleStoreAppId;
  late final List<String> permissions;

  AppEnvironmentEntity({
    required this.appName,
    required this.androidPackageName,
    required this.appleStoreAppId,
    required String permissions,
  }) {
    this.permissions = List.from(permissions.split(','))
        .where((item) => item.toString().isNotEmpty)
        .map<String>((item) => item.toString().trim())
        .toList();
  }
}
```

**Quando usar**: Quando é necessário transformar ou validar dados de entrada durante a construção.

---

## Cenário 9: Entity com BaseEntity (Persistência)

Entidades que representam dados persistidos em banco de dados. Devem estender `BaseEntity`.

### BaseEntity (classe abstrata)

```dart
import 'package:clean_code_domain/src/parsers/parser_to_json.dart';

abstract class BaseEntity extends ParserToJson {
  final String objectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseEntity({
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
  });

  BaseEntity copyWith({
    String? objectId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'createdAt': createdAt?.toString(),
      'updatedAt': updatedAt?.toString(),
    };
  }
}
```

### Entity Concreta estendendo BaseEntity

```dart
import 'package:clean_code_domain/clean_code_domain.dart';

class WebVisitHistoryEntity extends BaseEntity {
  final String website;
  final String ip;
  final String? userAgent;
  final String? country;
  final String? countryCode;
  final String? countryFlag;
  final String? region;
  final String? regionName;
  final String? city;
  final String? zip;
  final double? lat;
  final double? lon;
  final String? timezone;
  final String? isp;
  final String? org;
  final String? ispOrg;

  WebVisitHistoryEntity({
    required this.website,
    required this.ip,
    required this.userAgent,
    required this.country,
    required this.countryCode,
    required this.countryFlag,
    required this.region,
    required this.regionName,
    required this.city,
    required this.zip,
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.isp,
    required this.org,
    required this.ispOrg,
    required super.objectId,
    required super.createdAt,
    required super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'website': website,
      'ip': ip,
      'userAgent': userAgent,
      'country': country,
      'countryCode': countryCode,
      'countryFlag': countryFlag,
      'region': region,
      'regionName': regionName,
      'city': city,
      'zip': zip,
      'lat': lat,
      'lon': lon,
      'timezone': timezone,
      'isp': isp,
      'org': org,
      'ispOrg': ispOrg,
      ...super.toMap(),
    };
  }

  String get countryComplete {
    if (city == null ||
        region == null ||
        country == null ||
        countryCode == null) {
      return '';
    }
    return '$city-$region, $country ($countryCode)';
  }

  @override
  WebVisitHistoryEntity copyWith({
    String? website,
    String? ip,
    String? userAgent,
    String? country,
    String? countryCode,
    String? countryFlag,
    String? region,
    String? regionName,
    String? city,
    String? zip,
    double? lat,
    double? lon,
    String? timezone,
    String? isp,
    String? org,
    String? ispOrg,
    String? objectId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WebVisitHistoryEntity(
      website: website ?? this.website,
      ip: ip ?? this.ip,
      userAgent: userAgent ?? this.userAgent,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      countryFlag: countryFlag ?? this.countryFlag,
      region: region ?? this.region,
      regionName: regionName ?? this.regionName,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      timezone: timezone ?? this.timezone,
      isp: isp ?? this.isp,
      org: org ?? this.org,
      ispOrg: ispOrg ?? this.ispOrg,
      objectId: objectId ?? this.objectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

**Pontos importantes**:

- Usar `super.objectId`, `super.createdAt`, `super.updatedAt` no construtor
- No `toMap()`, usar spread operator `...super.toMap()` para incluir campos da base
- O `copyWith()` deve incluir todos os campos próprios e os campos da `BaseEntity`
- Não implementar `toString()` - `ParserToJson` já fornece implementação automática

---

## Cenário 10: Entity com Custom toString

Entidades que sobrescrevem `toString()` com formato personalizado (casos excepcionais).

```dart
class ShareResultEntity {
  final String? raw;
  final String status;

  ShareResultEntity({required this.raw, required this.status});

  @override
  String toString() {
    return '[$status] $raw'.trim();
  }
}
```

**Quando usar**: Apenas quando o formato de string precisa ser diferente do Map para fins de logging/debugging. Na maioria dos casos, não sobrescrever `toString()`.

---

## Checklist para Criar uma Nova Entity

- [ ] Nome da classe segue o padrão `NomeEntity`
- [ ] Todos os campos são `final`
- [ ] Construtor nomeado com parâmetros nomeados (`{}`)
- [ ] Campos obrigatórios usam `required`
- [ ] Campos opcionais usam tipo nullable (`Type?`)
- [ ] Se precisa de serialização: estende `ParserToJson`
- [ ] Se é persistida em banco: estende `BaseEntity`
- [ ] Implementar `toMap()` se estende `ParserToJson` ou `BaseEntity`
- [ ] Não implementar `toString()` (herdado de `ParserToJson`)
- [ ] Implementar `copyWith()` se a entidade pode ser atualizada parcialmente
- [ ] Ordenar campos: campos obrigatórios primeiro, opcionais depois
- [ ] Ordenar parâmetros do construtor na mesma ordem dos campos

---

## Hierarquia de Classes

```
ParserToJson (abstract)
  ├── toString() => toMap().toString()
  └── toMap() (abstract)
        │
        ├── BaseEntity (abstract)
        │     ├── objectId, createdAt, updatedAt
        │     ├── toMap()
        │     └── copyWith() (abstract)
        │           │
        │           └── WebVisitHistoryEntity
        │
        ├── AppInfoEntity
        ├── DeviceInfoEntity
        ├── InstallationEntity
        ├── NotificationEntity
        ├── PushNotificationEntity
        └── UserEntity
```
