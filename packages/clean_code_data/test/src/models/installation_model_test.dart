import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InstallationModel', () {
    test('should create InstallationModel with all required fields', () {
      final model = InstallationModel(
        installationId: 'install-123',
        appName: 'TestApp',
        appVersion: '1.0.0',
        appIdentifier: 'com.test.app',
        channels: ['channel1', 'channel2'],
        gcmSenderId: 'sender-123',
        deviceToken: 'device-token-123',
        pushType: 'fcm',
        deviceId: 'device-123',
        deviceBrand: 'Google',
        deviceModel: 'Pixel 6',
        deviceType: 'mobile',
        deviceOsVersion: '13',
        timeZone: 'America/New_York',
        localeIdentifier: 'en_US',
        platform: 'android',
        ip: '192.168.1.1',
      );

      expect(model.installationId, 'install-123');
      expect(model.appName, 'TestApp');
      expect(model.appVersion, '1.0.0');
      expect(model.appIdentifier, 'com.test.app');
      expect(model.channels, ['channel1', 'channel2']);
      expect(model.gcmSenderId, 'sender-123');
      expect(model.deviceToken, 'device-token-123');
      expect(model.pushType, 'fcm');
      expect(model.deviceId, 'device-123');
      expect(model.deviceBrand, 'Google');
      expect(model.deviceModel, 'Pixel 6');
      expect(model.deviceType, 'mobile');
      expect(model.deviceOsVersion, '13');
      expect(model.timeZone, 'America/New_York');
      expect(model.localeIdentifier, 'en_US');
      expect(model.platform, 'android');
      expect(model.ip, '192.168.1.1');
    });

    test('should create InstallationModel from valid map', () {
      final map = <String, dynamic>{
        'installationId': 'install-456',
        'appName': 'MyApp',
        'appVersion': '2.0.0',
        'appIdentifier': 'com.my.app',
        'channels': ['dev', 'prod'],
        'GCMSenderId': 'sender-456',
        'deviceToken': 'token-456',
        'pushType': 'fcm',
        'deviceId': 'device-456',
        'deviceBrand': 'Samsung',
        'deviceModel': 'Galaxy S22',
        'deviceType': 'mobile',
        'deviceOsVersion': '14',
        'timeZone': 'America/Sao_Paulo',
        'localeIdentifier': 'pt_BR',
        'platform': 'android',
        'ip': '10.0.0.1',
      };

      final model = InstallationModel.fromMap(map);

      expect(model.installationId, 'install-456');
      expect(model.appName, 'MyApp');
      expect(model.appVersion, '2.0.0');
      expect(model.appIdentifier, 'com.my.app');
      expect(model.channels, ['dev', 'prod']);
      expect(model.gcmSenderId, 'sender-456');
      expect(model.deviceToken, 'token-456');
      expect(model.pushType, 'fcm');
      expect(model.deviceId, 'device-456');
      expect(model.deviceBrand, 'Samsung');
      expect(model.deviceModel, 'Galaxy S22');
      expect(model.deviceType, 'mobile');
      expect(model.deviceOsVersion, '14');
      expect(model.timeZone, 'America/Sao_Paulo');
      expect(model.localeIdentifier, 'pt_BR');
      expect(model.platform, 'android');
      expect(model.ip, '10.0.0.1');
    });

    test('should handle empty channels in fromMap', () {
      final map = <String, dynamic>{
        'installationId': 'install-789',
        'appName': 'TestApp',
        'appVersion': '1.0.0',
        'appIdentifier': 'com.test.app',
        'channels': [],
        'GCMSenderId': 'sender-789',
        'deviceToken': 'token-789',
        'pushType': 'fcm',
        'deviceId': 'device-789',
        'deviceBrand': 'Apple',
        'deviceModel': 'iPhone 14',
        'deviceType': 'mobile',
        'deviceOsVersion': '16',
        'timeZone': 'America/New_York',
        'localeIdentifier': 'en_US',
        'platform': 'ios',
        'ip': '172.16.0.1',
      };

      final model = InstallationModel.fromMap(map);

      expect(model.channels, isEmpty);
    });

    test('should throw BaseException when fromMap receives invalid map', () {
      final invalidMap = <String, dynamic>{};

      expect(
        () => InstallationModel.fromMap(invalidMap),
        throwsA(isA<BaseException>()),
      );
    });

    test('should throw BaseException with complement containing map data', () {
      final invalidMap = <String, dynamic>{'invalid': 'data'};

      try {
        InstallationModel.fromMap(invalidMap);
        fail('Expected BaseException');
      } on BaseException catch (e) {
        expect(e.complement, 'Json Data: $invalidMap');
      }
    });
  });
}
