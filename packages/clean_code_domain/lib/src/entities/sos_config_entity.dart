class SosConfigEntity {
  final bool onlyPolice;
  final bool onlySafetyContacts;

  SosConfigEntity({
    required this.onlyPolice,
    required this.onlySafetyContacts,
  });

  Map<String, dynamic> toMap() {
    return {
      'onlyPolice': onlyPolice,
      'onlySafetyContacts': onlySafetyContacts,
    };
  }
}
