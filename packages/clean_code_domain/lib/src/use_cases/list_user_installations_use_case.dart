import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ListUserInstallationsUseCase {
  Future<List<InstallationEntity>> call(String userId);
}
