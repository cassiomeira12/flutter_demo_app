import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetInstallationAppUseCase {
  Future<InstallationEntity> call();
}
