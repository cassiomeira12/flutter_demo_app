import 'package:core/core.dart';
import 'package:settings/src/domain/domain.dart';

abstract class DynamicIconService {
  Future<Result<bool>> supportsAlternateIcons();

  Future<Result<String>> currentIcon();

  Future<Result<void>> changeIcon(String icon);

  Future<Result<void>> setDefaultIcon();

  List<DynamicIconEntity> iconsAvailable();
}
