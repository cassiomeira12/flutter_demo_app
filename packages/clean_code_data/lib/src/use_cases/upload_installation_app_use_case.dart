import 'package:core/core.dart';

class UploadInstallationAppUseCaseImpl implements UploadInstallationAppUseCase {
  final AppInstallationService _service;
  final LocalStorageUseCase _localStorageUseCase;

  UploadInstallationAppUseCaseImpl({
    required AppInstallationService appInstallationService,
    required LocalStorageUseCase localStorageUseCase,
  }) : _service = appInstallationService,
       _localStorageUseCase = localStorageUseCase;

  @override
  Future<InstallationEntity> call() async {
    InstallationEntity installation = await _service.getInstallation();
    final storageToken = await _localStorageUseCase.get<String>(PUSH_TOKEN);
    final token = installation.deviceToken;
    installation = await _service.upload(installation);
    if (token != null && storageToken != token) {
      await _localStorageUseCase.set(PUSH_TOKEN, token);
    }
    return installation;
  }
}
