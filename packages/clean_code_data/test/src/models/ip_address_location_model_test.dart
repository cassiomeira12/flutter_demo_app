import 'package:clean_code_data/clean_code_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IpAddressLocationModel', () {
    test('should create IpAddressLocationModel with all required fields', () {
      final model = IpAddressLocationModel(
        country: 'United States',
        countryCode: 'US',
        region: 'CA',
        regionName: 'California',
        city: 'San Francisco',
        zip: '94102',
        latitude: 37.7749,
        longitude: -122.4194,
        timezone: 'America/Los_Angeles',
        isp: 'Comcast',
        org: 'Comcast Cable',
        ispOrg: 'AS7922',
        ip: '192.168.1.1',
      );

      expect(model.country, 'United States');
      expect(model.countryCode, 'US');
      expect(model.region, 'CA');
      expect(model.regionName, 'California');
      expect(model.city, 'San Francisco');
      expect(model.zip, '94102');
      expect(model.latitude, 37.7749);
      expect(model.longitude, -122.4194);
      expect(model.timezone, 'America/Los_Angeles');
      expect(model.isp, 'Comcast');
      expect(model.org, 'Comcast Cable');
      expect(model.ispOrg, 'AS7922');
      expect(model.ip, '192.168.1.1');
    });

    test('should create IpAddressLocationModel from valid map', () {
      final map = <String, dynamic>{
        'country': 'Brazil',
        'countryCode': 'BR',
        'region': 'SP',
        'regionName': 'Sao Paulo',
        'city': 'Sao Paulo',
        'zip': '01000-000',
        'lat': -23.5505,
        'lon': -46.6333,
        'timezone': 'America/Sao_Paulo',
        'isp': 'Vivo',
        'org': 'Telefonica Brasil',
        'as': 'AS18881',
        'query': '200.100.50.25',
      };

      final model = IpAddressLocationModel.fromMap(map);

      expect(model.country, 'Brazil');
      expect(model.countryCode, 'BR');
      expect(model.region, 'SP');
      expect(model.regionName, 'Sao Paulo');
      expect(model.city, 'Sao Paulo');
      expect(model.zip, '01000-000');
      expect(model.latitude, -23.5505);
      expect(model.longitude, -46.6333);
      expect(model.timezone, 'America/Sao_Paulo');
      expect(model.isp, 'Vivo');
      expect(model.org, 'Telefonica Brasil');
      expect(model.ispOrg, 'AS18881');
      expect(model.ip, '200.100.50.25');
    });

    test('should map lat/lon from map to latitude/longitude', () {
      final map = <String, dynamic>{
        'country': 'US',
        'countryCode': 'US',
        'region': 'NY',
        'regionName': 'New York',
        'city': 'New York',
        'zip': '10001',
        'lat': 40.7128,
        'lon': -74.0060,
        'timezone': 'America/New_York',
        'isp': 'Verizon',
        'org': 'Verizon',
        'as': 'AS701',
        'query': '10.0.0.1',
      };

      final model = IpAddressLocationModel.fromMap(map);

      expect(model.latitude, 40.7128);
      expect(model.longitude, -74.0060);
    });

    test(
      'should create IpAddressLocationModel with null values from empty map',
      () {
        final map = <String, dynamic>{};

        final model = IpAddressLocationModel.fromMap(map);

        expect(model.country, isNull);
        expect(model.countryCode, isNull);
        expect(model.region, isNull);
        expect(model.regionName, isNull);
        expect(model.city, isNull);
        expect(model.zip, isNull);
        expect(model.latitude, isNull);
        expect(model.longitude, isNull);
        expect(model.timezone, isNull);
        expect(model.isp, isNull);
        expect(model.org, isNull);
        expect(model.ispOrg, isNull);
        expect(model.ip, isNull);
      },
    );
  });
}
