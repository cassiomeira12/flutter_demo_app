enum RemoteFlagsEnum {
  updateApp('update_app'),
  updateAppRequired('update_app_required'),
  blockingApp('blocking_app'),
  downloadAndroidStore('download_android_store'),
  downloadAppleStore('download_apple_store')
  ;

  final String name;

  const RemoteFlagsEnum(this.name);
}
