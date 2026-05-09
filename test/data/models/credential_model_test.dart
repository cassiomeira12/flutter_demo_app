import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CredentialModel', () {
    group('Sucesso', () {
      test('deve criar CredentialModel com todos os campos obrigatórios', () {
        final model = CredentialModel(
          objectId: 'cred-123',
          name: 'GitHub',
          userName: 'john_doe',
          password: 'secure-password',
          secretKeyOTP: 'JBSWY3DPEHPK3PXP',
          url: 'https://github.com',
          faviconUrl: 'https://github.com/favicon.ico',
          notes: 'Minhas credenciais do GitHub',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        );

        expect(model.objectId, 'cred-123');
        expect(model.name, 'GitHub');
        expect(model.userName, 'john_doe');
        expect(model.password, 'secure-password');
        expect(model.secretKeyOTP, 'JBSWY3DPEHPK3PXP');
        expect(model.url, 'https://github.com');
        expect(model.faviconUrl, 'https://github.com/favicon.ico');
        expect(model.notes, 'Minhas credenciais do GitHub');
        expect(model.createdAt, DateTime(2024));
        expect(model.updatedAt, DateTime(2024));
      });

      test('deve criar CredentialModel a partir de map válido', () {
        final map = <String, dynamic>{
          'objectId': 'cred-456',
          'name': 'GitLab',
          'userName': 'jane_doe',
          'password': 'gitlab-pass',
          'secretKeyOTP': 'SECRET123',
          'url': 'https://gitlab.com',
          'faviconUrl': 'https://gitlab.com/favicon.ico',
          'notes': 'Conta do GitLab',
          'createdAt': '2024-02-01T00:00:00.000',
          'updatedAt': '2024-02-02T00:00:00.000',
        };

        final model = CredentialModel.fromMap(map);

        expect(model.objectId, 'cred-456');
        expect(model.name, 'GitLab');
        expect(model.userName, 'jane_doe');
        expect(model.password, 'gitlab-pass');
        expect(model.secretKeyOTP, 'SECRET123');
        expect(model.url, 'https://gitlab.com');
        expect(model.faviconUrl, 'https://gitlab.com/favicon.ico');
        expect(model.notes, 'Conta do GitLab');
        expect(model.createdAt, isNotNull);
        expect(model.updatedAt, isNotNull);
      });

      test('deve criar CredentialModel com campos opcionais nulos', () {
        final map = <String, dynamic>{
          'objectId': 'cred-null-fields',
          'name': 'Test Service',
          // todos os campos opcionais são nulos
          'userName': null,
          'password': null,
          'secretKeyOTP': null,
          'url': null,
          'faviconUrl': null,
          'notes': null,
          'createdAt': null,
          'updatedAt': null,
        };

        final model = CredentialModel.fromMap(map);

        expect(model.objectId, 'cred-null-fields');
        expect(model.name, 'Test Service');
        expect(model.userName, isNull);
        expect(model.password, isNull);
        expect(model.secretKeyOTP, isNull);
        expect(model.url, isNull);
        expect(model.faviconUrl, isNull);
        expect(model.notes, isNull);
        expect(model.createdAt, isNull);
        expect(model.updatedAt, isNull);
      });

      test('deve usar valores padrão quando campos não estão presente', () {
        final map = <String, dynamic>{
          'objectId': 'cred-defaults',
          'name': 'Default Service',
          // sem os campos opcionais
        };

        final model = CredentialModel.fromMap(map);

        expect(model.objectId, 'cred-defaults');
        expect(model.name, 'Default Service');
        expect(model.userName, isNull);
        expect(model.password, isNull);
        expect(model.secretKeyOTP, isNull);
        expect(model.url, isNull);
        expect(model.faviconUrl, isNull);
        expect(model.notes, isNull);
      });

      test('deve retornar faviconUrl_formatado quando faviconUrl existe', () {
        final map = <String, dynamic>{
          'objectId': 'cred-favicon',
          'name': 'MyApp',
          'faviconUrl': 'https://myapp.com/icon.png',
          'createdAt': '2024-01-01T00:00:00.000',
          'updatedAt': '2024-01-01T00:00:00.000',
        };

        final model = CredentialModel.fromMap(map);

        expect(model.favIconUrlFormatted, 'https://myapp.com/icon.png');
      });

      test(
        'deve gerar favicon_url_formatado com ui-avatars quando faviconUrl é nulo',
        () {
          final map = <String, dynamic>{
            'objectId': 'cred-fallback-favicon',
            'name': 'GeneratedAvatar',
            'createdAt': '2024-01-01T00:00:00.000',
            'updatedAt': '2024-01-01T00:00:00.000',
          };

          final model = CredentialModel.fromMap(map);

          expect(model.favIconUrlFormatted, contains('ui-avatars.com'));
          expect(model.favIconUrlFormatted, contains('GeneratedAvatar'));
        },
      );

      test('deve converter para map corretamente', () {
        final model = CredentialModel(
          objectId: 'cred-to-map',
          name: 'ToMap Test',
          userName: 'testuser',
          password: 'testpass',
          secretKeyOTP: 'OTP123',
          url: 'https://test.com',
          faviconUrl: 'https://test.com/icon.png',
          notes: 'Test notes',
          createdAt: DateTime(2024, 3),
          updatedAt: DateTime(2024, 3, 2),
        );

        final map = model.toMap();

        expect(map['objectId'], 'cred-to-map');
        expect(map['name'], 'ToMap Test');
        expect(map['userName'], 'testuser');
        expect(map['password'], 'testpass');
        expect(map['secretKeyOTP'], 'OTP123');
        expect(map['url'], 'https://test.com');
        expect(map['faviconUrl'], 'https://test.com/icon.png');
        expect(map['notes'], 'Test notes');
        expect(map['createdAt'], isNotNull);
        expect(map['updatedAt'], isNotNull);
      });
    });

    group('Erro', () {
      test(
        'deve lançar BaseException quando fromMap recebe tipo de dados incorreto',
        () {
          final invalidMap = <String, dynamic>{
            'objectId': 12.34, // objectId deveria ser String
            'name': 'Test',
            'createdAt': '2024-01-01T00:00:00.000',
            'updatedAt': '2024-01-01T00:00:00.000',
          };

          expect(
            () => CredentialModel.fromMap(invalidMap),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando fromMap recebe DateTime inválido',
        () {
          final invalidMap = <String, dynamic>{
            'objectId': 'cred-date-error',
            'name': 'Test',
            'createdAt': 'invalid-date', // DateTime inválido
            'updatedAt': 'invalid-date',
          };

          expect(
            () => CredentialModel.fromMap(invalidMap),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test('deve usar valores padrão para campos ausentes', () {
        final map = <String, dynamic>{};

        final model = CredentialModel.fromMap(map);

        // O modelo usa valores padrão ao invés de lançar exceção
        expect(model.objectId, '');
        expect(model.name, '');
      });
    });
  });
}
