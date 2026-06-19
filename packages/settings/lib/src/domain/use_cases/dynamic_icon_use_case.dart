import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:settings/src/domain/domain.dart';

abstract class DynamicIconUseCase extends UseCase {
  Future<Result<bool>> supportsAlternateIcons();

  Future<Result<String>> currentIcon();

  Future<Result<void>> changeIcon(String icon);

  Future<Result<void>> setDefaultIcon();

  List<DynamicIconEntity> iconsAvailable();
}

class DynamicIconUseCaseImpl implements DynamicIconUseCase {
  final DynamicIconService _dynamicIconService;

  DynamicIconUseCaseImpl({required this._dynamicIconService});

  @override
  Future<Result<bool>> supportsAlternateIcons() {
    return _dynamicIconService.supportsAlternateIcons();
  }

  @override
  Future<Result<String>> currentIcon() {
    return _dynamicIconService.currentIcon();
  }

  @override
  Future<Result<void>> changeIcon(String icon) {
    return _dynamicIconService.changeIcon(icon);
  }

  @override
  Future<Result<void>> setDefaultIcon() {
    return _dynamicIconService.setDefaultIcon();
  }

  @override
  List<DynamicIconEntity> iconsAvailable() {
    return _dynamicIconService.iconsAvailable();
  }
}
