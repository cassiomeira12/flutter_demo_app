class RemoteFlag<T> {
  final bool isEnabled;
  final T? value;

  RemoteFlag({
    required this.isEnabled,
    required this.value,
  });
}
