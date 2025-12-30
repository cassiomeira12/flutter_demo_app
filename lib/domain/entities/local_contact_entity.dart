class LocalContactEntity {
  final String name;
  final String phoneNumber;

  LocalContactEntity({
    required this.name,
    required this.phoneNumber,
  });

  @override
  String toString() {
    return 'name: $name, phoneNumber: $phoneNumber';
  }
}
