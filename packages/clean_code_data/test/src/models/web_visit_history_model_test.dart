import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WebVisitHistoryModel', () {
    test('should create WebVisitHistoryModel with all required fields', () {
      final createdAt = DateTime(2024, 1, 1, 10);
      final updatedAt = DateTime(2024, 1, 2, 10);

      final model = WebVisitHistoryModel(
        objectId: 'visit-123',
        website: 'https://example.com',
        ip: '192.168.1.1',
        userAgent: 'Mozilla/5.0',
        country: 'United States',
        countryCode: 'US',
        countryFlag: '🇺🇸',
        region: 'CA',
        regionName: 'California',
        city: 'San Francisco',
        zip: '94102',
        lat: 37.7749,
        lon: -122.4194,
        timezone: 'America/Los_Angeles',
        isp: 'Comcast',
        org: 'Comcast Cable',
        ispOrg: 'AS7922',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(model.objectId, 'visit-123');
      expect(model.website, 'https://example.com');
      expect(model.ip, '192.168.1.1');
      expect(model.userAgent, 'Mozilla/5.0');
      expect(model.country, 'United States');
      expect(model.countryCode, 'US');
      expect(model.region, 'CA');
      expect(model.city, 'San Francisco');
      expect(model.zip, '94102');
      expect(model.lat, 37.7749);
      expect(model.lon, -122.4194);
      expect(model.timezone, 'America/Los_Angeles');
      expect(model.isp, 'Comcast');
      expect(model.createdAt, createdAt);
      expect(model.updatedAt, updatedAt);
    });

    test('should create WebVisitHistoryModel from valid map', () {
      final map = <String, dynamic>{
        'objectId': 'visit-456',
        'website': 'https://test.com',
        'ip': '10.0.0.1',
        'userAgent': 'Chrome/120.0',
        'country': 'Brazil',
        'countryCode': 'BR',
        'countryFlag': '🇧🇷',
        'region': 'SP',
        'regionName': 'Sao Paulo',
        'city': 'Sao Paulo',
        'zip': '01000-000',
        'lat': -23.5505,
        'lon': -46.6333,
        'timezone': 'America/Sao_Paulo',
        'isp': 'Vivo',
        'org': 'Telefonica',
        'as': 'AS18881',
        'createdAt': '2024-02-01T10:00:00Z',
        'updatedAt': '2024-02-02T10:00:00Z',
      };

      final model = WebVisitHistoryModel.fromMap(map);

      expect(model.objectId, 'visit-456');
      expect(model.website, 'https://test.com');
      expect(model.ip, '10.0.0.1');
      expect(model.userAgent, 'Chrome/120.0');
      expect(model.country, 'Brazil');
      expect(model.countryCode, 'BR');
      expect(model.region, 'SP');
      expect(model.city, 'Sao Paulo');
      expect(model.zip, '01000-000');
      expect(model.lat, -23.5505);
      expect(model.lon, -46.6333);
      expect(model.isp, 'Vivo');
      expect(model.org, 'Telefonica');
      expect(model.ispOrg, 'AS18881');
    });

    test('should parse createdAt and updatedAt as DateTime from map', () {
      final map = <String, dynamic>{
        'objectId': 'visit-dates',
        'website': 'https://dates.com',
        'ip': '10.0.0.2',
        'createdAt': '2024-03-01T15:30:00Z',
        'updatedAt': '2024-03-02T16:45:00Z',
      };

      final model = WebVisitHistoryModel.fromMap(map);

      expect(model.createdAt, isA<DateTime>());
      expect(model.updatedAt, isA<DateTime>());
      expect(model.createdAt?.year, 2024);
      expect(model.createdAt?.month, 3);
      expect(model.createdAt?.day, 1);
    });

    test('should handle null createdAt and updatedAt in fromMap', () {
      final map = <String, dynamic>{
        'objectId': 'visit-null-dates',
        'website': 'https://nulldates.com',
        'ip': '10.0.0.3',
        'createdAt': null,
        'updatedAt': null,
      };

      final model = WebVisitHistoryModel.fromMap(map);

      expect(model.createdAt, isNull);
      expect(model.updatedAt, isNull);
    });

    test('should use default empty strings for required string fields', () {
      final map = <String, dynamic>{
        'objectId': 'visit-defaults',
        'website': 'https://defaults.com',
        'ip': '10.0.0.4',
        'createdAt': '2024-04-01T00:00:00Z',
        'updatedAt': '2024-04-02T00:00:00Z',
      };

      final model = WebVisitHistoryModel.fromMap(map);

      expect(model.objectId, 'visit-defaults');
      expect(model.website, 'https://defaults.com');
      expect(model.ip, '10.0.0.4');
      expect(model.userAgent, isNull);
      expect(model.country, isNull);
      expect(model.countryCode, isNull);
      expect(model.city, isNull);
    });

    test('should handle null optional fields in fromMap', () {
      final map = <String, dynamic>{
        'objectId': 'visit-null-fields',
        'website': 'https://nullfields.com',
        'ip': '10.0.0.5',
        'userAgent': null,
        'country': null,
        'countryCode': null,
        'countryFlag': null,
        'region': null,
        'regionName': null,
        'city': null,
        'zip': null,
        'lat': null,
        'lon': null,
        'timezone': null,
        'isp': null,
        'org': null,
        'as': null,
        'createdAt': '2024-05-01T00:00:00Z',
        'updatedAt': '2024-05-02T00:00:00Z',
      };

      final model = WebVisitHistoryModel.fromMap(map);

      expect(model.userAgent, isNull);
      expect(model.country, isNull);
      expect(model.lat, isNull);
      expect(model.lon, isNull);
      expect(model.timezone, isNull);
    });

    test(
      'should create WebVisitHistoryModel with default values from empty map',
      () {
        final map = <String, dynamic>{};

        final model = WebVisitHistoryModel.fromMap(map);

        expect(model.objectId, '');
        expect(model.website, '');
        expect(model.ip, '');
        expect(model.createdAt, isNull);
        expect(model.updatedAt, isNull);
      },
    );
  });
}
