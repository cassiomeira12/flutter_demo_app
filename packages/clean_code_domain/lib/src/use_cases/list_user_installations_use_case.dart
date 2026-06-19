import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ListUserInstallationsUseCase
    extends BaseUseCaseAsyncParam<List<InstallationEntity>, String> {}

class ListUserInstallationsUseCaseImpl implements ListUserInstallationsUseCase {
  final AppInstallationService _appInstallationService;

  ListUserInstallationsUseCaseImpl({required this._appInstallationService});

  @override
  Future<List<InstallationEntity>> call(String userId) {
    return _appInstallationService.list(userId);
  }
}
