import 'package:clean_code_domain/clean_code_domain.dart';

abstract class AppInfoService {
  Future<AppInfoEntity> getAppInfo();
}
