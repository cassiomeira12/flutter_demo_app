enum RemoteFlagsEnum {
  updateApp('update_app'),
  updateAppData('update_app_data'),
  updateAppRequired('update_app_required'),
  blockingApp('blocking_app');

  final String name;

  const RemoteFlagsEnum(this.name);
}
