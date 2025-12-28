class CredentialEntity {
  final String objectId;
  final String name;
  final String? userName;
  final String? password;
  final String? secretKeyOTP;
  final String? url;
  final String? faviconUrl;
  final String? notes;
  final String createdAt;
  final String updatedAt;

  CredentialEntity({
    required this.objectId,
    required this.name,
    required this.userName,
    required this.password,
    required this.secretKeyOTP,
    required this.url,
    required this.faviconUrl,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  CredentialEntity copyWith({
    String? objectId,
    String? name,
    String? userName,
    String? password,
    String? secretKeyOTP,
    String? url,
    String? faviconUrl,
    String? notes,
    String? createdAt,
    String? updatedAt,
  }) {
    return CredentialEntity(
      objectId: objectId ?? this.objectId,
      name: name ?? this.name,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      secretKeyOTP: secretKeyOTP ?? this.secretKeyOTP,
      url: url ?? this.url,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'name': name,
      'userName': userName,
      'password': password,
      'secretKeyOTP': secretKeyOTP,
      'url': url,
      'faviconUrl': faviconUrl,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String get favIconUrlFormatted =>
      faviconUrl ?? 'https://ui-avatars.com/api/?format=png&name=$name';

  @override
  String toString() {
    return toMap().toString();
  }
}
