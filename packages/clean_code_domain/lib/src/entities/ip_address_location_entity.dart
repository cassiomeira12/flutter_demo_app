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
}
