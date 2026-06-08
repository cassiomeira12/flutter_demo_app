import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppInfoServiceImpl implements AppInfoService {
  @override
  Future<AppInfoEntity> getAppInfo() async {
    try {
      final appInfo = await AppInfoData.get();
      final package = appInfo.package;

      const String appName = String.fromEnvironment('app_name');
      final String packageName = Platform.isWeb
          ? 'Web $appName'
                .replaceAll(RegExp('[()]'), '')
                .replaceAll(RegExp(r'\s+'), '_')
                .trim()
                .toLowerCase()
          : package.packageName;

      return AppInfoEntity(
        appName: package.appName,
        packageName: packageName,
        buildSignature: package.buildSignature,
        installerStore: package.installerStore,
        version: package.version.toString().split('+').first,
        build: package.buildNumber,
      );
    } on MissingPluginException {
      rethrow;
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }
}
