import 'package:clean_code_domain/clean_code_domain.dart';

abstract class AppInstallationService {
  Future<InstallationEntity> getInstallation();

  Future<InstallationEntity> upload(InstallationEntity installation);

  Future<List<InstallationEntity>> list(String userId);
}
