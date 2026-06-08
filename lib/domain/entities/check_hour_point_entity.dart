class CheckHourPointEntity {
  final String objectId;
  final bool manual;
  final String? value;

  CheckHourPointEntity({
    required this.objectId,
    required this.manual,
    required this.value,
  });

  int get hour {
    if (value == null) return 0;
    if (value!.split(':').isEmpty) return 0;
    return int.tryParse(value!.split(':').first) ?? 0;
  }

  int get minute {
    if (value == null) return 0;
    if (value!.split(':').isEmpty) return 0;
    return int.tryParse(value!.split(':').last) ?? 0;
  }
}
