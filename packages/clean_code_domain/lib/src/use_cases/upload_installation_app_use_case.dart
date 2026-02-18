import 'package:core/core.dart';

abstract class UploadInstallationAppUseCase {
  Future<InstallationEntity> call();
}
