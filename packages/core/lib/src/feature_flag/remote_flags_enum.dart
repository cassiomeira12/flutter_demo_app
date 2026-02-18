enum RemoteFlagsEnum {
  updateApp('update_app'),
  updateAppRequired('update_app_required'),
  blockingApp('blocking_app')
  ;

  final String name;

  const RemoteFlagsEnum(this.name);
}
