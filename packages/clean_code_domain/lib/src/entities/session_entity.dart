class SessionEntity {
  final String? token;

  SessionEntity({this.token});

  bool get isAuthenticated => token != null;
}
