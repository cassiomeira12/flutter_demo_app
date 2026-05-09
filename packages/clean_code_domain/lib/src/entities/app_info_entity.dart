import 'package:clean_code_domain/clean_code_domain.dart';

class AppInfoEntity extends ParserToJson {
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

  @override
  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'packageName': packageName,
      'buildSignature': buildSignature,
      'installerStore': installerStore,
      'version': version,
      'build': build,
    };
  }
}
