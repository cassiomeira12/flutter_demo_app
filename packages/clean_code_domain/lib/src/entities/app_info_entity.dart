class AppInfoEntity {
  final String appName;
  final String packageName;
  final String buildSignature;
  final String? installerStore;
  final String version;
  final String build;

  AppInfoEntity({
    required this.appName,
    required this.packageName,
    required this.buildSignature,
    required this.installerStore,
    required this.version,
    required this.build,
  });

  String get formattedName => '$version ($build)';

  String get versionOnly => version.split('-').first;
}
