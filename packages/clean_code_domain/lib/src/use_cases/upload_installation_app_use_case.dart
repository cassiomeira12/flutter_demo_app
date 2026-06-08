import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

abstract class UploadInstallationAppUseCase
    extends BaseUseCaseAsync<InstallationEntity> {}

class UploadInstallationAppUseCaseImpl implements UploadInstallationAppUseCase {
  final AppInstallationService _appInstallationService;
  final LocalStorageUseCase _localStorageUseCase;

  UploadInstallationAppUseCaseImpl({
    required this._appInstallationService,
    required this._localStorageUseCase,
  });

  @override
  Future<InstallationEntity> call() async {
    InstallationEntity installation = await _appInstallationService
        .getInstallation();
    final storageToken = await _localStorageUseCase.get<String>(PUSH_TOKEN);
    final token = installation.deviceToken;
    installation = await _appInstallationService.upload(installation);
    if (token != null && storageToken != token) {
      await _localStorageUseCase.set(PUSH_TOKEN, token);
    }
    return installation;
  }
}
