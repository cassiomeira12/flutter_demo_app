class AppEnvironmentEntity {
  final String appName;
  final String androidPackageName;
  final String appleStoreAppId;
  late final List<String> permissions;
  final String webBaseHREF;

  AppEnvironmentEntity({
    required this.appName,
    required this.androidPackageName,
    required this.appleStoreAppId,
    required String permissions,
    required this.webBaseHREF,
  }) {
    this.permissions = List.from(permissions.split(','))
        .where((item) => item.toString().isNotEmpty)
        .map<String>((item) => item.toString().trim())
        .toList();
  }
}
