import 'package:clean_code_domain/clean_code_domain.dart';
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
        latitude: map['latitude'],
        longitude: map['longitude'],
        timezone: map['timezone'],
        isp: map['isp'],
        org: map['org'],
        ispOrg: map['as '],
        ip: map['query'],
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stacktrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
