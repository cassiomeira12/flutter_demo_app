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
  final DynamicIconService _service;

  DynamicIconUseCaseImpl({
    required DynamicIconService dynamicIconService,
  }) : _service = dynamicIconService;

  @override
  Future<Result<bool>> supportsAlternateIcons() {
    return _service.supportsAlternateIcons();
  }

  @override
  Future<Result<String>> currentIcon() {
    return _service.currentIcon();
  }

  @override
  Future<Result<void>> changeIcon(String icon) {
    return _service.changeIcon(icon);
  }

  @override
  Future<Result<void>> setDefaultIcon() {
    return _service.setDefaultIcon();
  }

  @override
  List<DynamicIconEntity> iconsAvailable() {
    return _service.iconsAvailable();
  }
}
