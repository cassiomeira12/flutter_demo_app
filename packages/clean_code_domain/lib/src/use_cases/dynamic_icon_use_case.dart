import 'package:core/core.dart';

abstract class DynamicIconUseCase {
  Future<Result<bool>> supportsAlternateIcons();

  Future<Result<String>> currentIcon();

  Future<Result<void>> changeIcon(String icon);

  Future<Result<void>> setDefaultIcon();

  List<DynamicIcon> iconsAvailable();
}

class DynamicIcon {
  final String name;
  final bool defaultIcon;
  final String path;

  DynamicIcon({
    required this.name,
    required this.defaultIcon,
    required this.path,
  });
}
