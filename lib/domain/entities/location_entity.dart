class LocationEntity {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final double? speed;
  final DateTime? date;

  LocationEntity({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.speed,
    this.date,
  });

  @override
  String toString() {
    return 'lat: $latitude lng: $longitude accuracy: $accuracy speed: $speed';
  }
}
