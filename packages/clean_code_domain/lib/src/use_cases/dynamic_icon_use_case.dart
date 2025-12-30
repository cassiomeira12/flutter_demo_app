abstract class DynamicIconUseCase {
  Future<bool> supportsAlternateIcons();

  Future<void> changeIcon(String? icon);

  Future<String?> currentIcon();
}
