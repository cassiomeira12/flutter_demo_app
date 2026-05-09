import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await DomainModuleBindings().injectDependencies();
    await InfraModuleBindings().injectDependencies();
  });

  tearDownAll(() {
    AppBinding.deleteAll();
  });

  test('auto ip address location success', () async {
    final IpAddressLocationDataSource ipAddressLocation = AppBinding.find();

    final Map<String, dynamic> data = await ipAddressLocation.getIpAddress();

    expect(data, isNotNull);
    expect(data, isNotEmpty);

    expect(data['country'], isNotNull);
    expect(data['countryCode'], isNotNull);
    expect(data['region'], isNotNull);
    expect(data['regionName'], isNotNull);
    expect(data['city'], isNotNull);
    expect(data['zip'], isNotNull);
    expect(data['lat'], isNotNull);
    expect(data['lon'], isNotNull);
    expect(data['timezone'], isNotNull);
    expect(data['isp'], isNotNull);
    expect(data['org'], isNotNull);
    expect(data['as'], isNotNull);
    expect(data['query'], isNotNull);
  });

  test('fixed ip address location success', () async {
    final IpAddressLocationDataSource ipAddressLocation = AppBinding.find();

    const String ip = '8.8.4.4';

    final Map<String, dynamic> data = await ipAddressLocation.getIpAddress(
      ip: ip,
    );

    expect(data, isNotNull);
    expect(data, isNotEmpty);

    expect(data['country'], 'United States');
    expect(data['countryCode'], 'US');
    expect(data['region'], 'VA');
    expect(data['regionName'], 'Virginia');
    expect(data['city'], 'Ashburn');
    expect(data['zip'], '20149');
    expect(data['lat'], 39.03);
    expect(data['lon'], -77.5);
    expect(data['timezone'], 'America/New_York');
    expect(data['isp'], 'Google LLC');
    expect(data['org'], 'Google Public DNS');
    expect(data['as'], 'AS15169 Google LLC');
    expect(data['query'], ip);
  });
}
