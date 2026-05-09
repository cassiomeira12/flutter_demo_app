enum RemoteFlagsEnum {
  updateApp('update_app', bool),
  updateAppRequired('update_app_required', bool),
  blockingApp('blocking_app', bool),
  downloadAndroidStore('download_android_store', bool),
  downloadAppleStore('download_apple_store', bool),
  sentryConfig('sentry_config', Map<String, dynamic>),
  ;

  final String name;
  final Type type;

  const RemoteFlagsEnum(this.name, this.type);
}
