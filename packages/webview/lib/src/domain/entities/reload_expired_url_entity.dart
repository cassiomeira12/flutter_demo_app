class ReloadExpiredUrlEntity {
  final bool enable;
  final RegExp pattern;
  final Duration expiredTime;

  ReloadExpiredUrlEntity({
    required this.enable,
    required this.pattern,
    required this.expiredTime,
  });
}
