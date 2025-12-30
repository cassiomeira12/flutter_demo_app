import 'package:clean_code_domain/clean_code_domain.dart';

class AppInfoModel extends AppInfoEntity {
  AppInfoModel({
    required super.appName,
    required super.packageName,
    required super.buildSignature,
    required super.installerStore,
    required super.version,
    required super.build,
  });

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

  @override
  String toString() {
    return toMap().toString();
  }
}
