import 'package:clean_code_domain/clean_code_domain.dart';
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
        timezone: map['zip'] as String?,
        isp: map['isp'] as String?,
        org: map['org'] as String?,
        ispOrg: map['as'] as String?,
        createdAt: map['createdAt'] ?? '',
        updatedAt: map['updatedAt'] ?? '',
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
