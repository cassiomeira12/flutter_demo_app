import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ListUserInstallationsUseCase
    extends BaseUseCaseAsyncParam<List<InstallationEntity>, String> {}

class ListUserInstallationsUseCaseImpl implements ListUserInstallationsUseCase {
  final AppInstallationService _service;

  ListUserInstallationsUseCaseImpl({
    required AppInstallationService appInstallationService,
  }) : _service = appInstallationService;

  @override
  Future<List<InstallationEntity>> call(String userId) {
    return _service.list(userId);
  }
}
