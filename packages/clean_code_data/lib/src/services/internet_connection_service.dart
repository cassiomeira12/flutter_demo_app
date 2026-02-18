import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class InternetConnectionServiceImpl implements InternetConnectionService {
  late InternetConnection _internetConnection;
  late StreamSubscription<InternetStatus> _stream;

  InternetConnectionServiceImpl() {
    _internetConnection = InternetConnection.createInstance();
    _stream = _internetConnection.onStatusChange.listen(
      _listenChangeStatus,
      onDone: () {
        _stream.pause();
      },
      onError: (error, stackTrace) {
        _stream.cancel();
      },
    );
  }

  InternetStatus? _lastStatus;

  final _listenerStreamList = List<StreamController<bool>>.empty(
    growable: true,
  );

  void _listenChangeStatus(InternetStatus status) {
    _clearInactiveStreams();
    if (_lastStatus != null && _lastStatus != status) {
      for (final streamController in _listenerStreamList) {
        streamController.add(status == InternetStatus.connected);
      }
    }
    _lastStatus = status;
  }

  void _clearInactiveStreams() {
    _listenerStreamList.removeWhere((streamController) {
      return streamController.isPaused || streamController.isClosed;
    });
  }

  @override
  void addStream(StreamController<bool> streamController) {
    _listenerStreamList.add(streamController);
  }

  @override
  Future<bool> hasInternetAccess() async {
    final bool result = await _internetConnection.hasInternetAccess;
    return result;
  }

  @override
  void pauseStream() {
    _stream.pause();
  }

  @override
  void resumeStream() {
    _stream.resume();
  }

  @override
  void dispose() {
    _clearInactiveStreams();
    if (_listenerStreamList.isEmpty) {
      _stream.cancel();
    }
  }
}
