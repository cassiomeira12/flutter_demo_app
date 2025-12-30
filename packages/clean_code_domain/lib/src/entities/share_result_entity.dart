class ShareResultEntity {
  final String? raw;
  final String status;

  ShareResultEntity({required this.raw, required this.status});

  @override
  String toString() {
    return '[$status] $raw'.trim();
  }
}
