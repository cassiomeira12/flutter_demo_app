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
  String toString() {
    return toMap().toString();
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
