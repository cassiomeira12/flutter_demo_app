import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class GetAppInfoUseCaseImpl implements GetAppInfoUseCase {
  final AppInfoService _service;

  GetAppInfoUseCaseImpl({required AppInfoService appInfoService})
    : _service = appInfoService;

  @override
  Future<AppInfoModel> call() async {
    var appInfo = await _service.getAppInfo();
    appInfo = appInfo as AppInfoModel;
    return appInfo;
  }
}
