import 'dart:async';

abstract class InternetConnectionService {
  Future<bool> hasInternetAccess();

  void addStream(StreamController<bool> streamController);

  void pauseStream();

  void resumeStream();

  void dispose();
}
