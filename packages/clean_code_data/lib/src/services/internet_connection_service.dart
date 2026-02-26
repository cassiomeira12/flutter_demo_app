import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class InternetConnectionServiceImpl implements InternetConnectionService {
  late InternetConnection _internetConnection;
  late StreamSubscription<InternetStatus> _internetConnectionSubscription;

  InternetConnectionServiceImpl() {
    _internetConnection = InternetConnection.createInstance();
    _internetConnectionSubscription = _internetConnection.onStatusChange.listen(
      _listenChangeStatus,
      onDone: () {
        _internetConnectionSubscription.pause();
      },
      onError: (error, stackTrace) {
        _internetConnectionSubscription.cancel();
        Log.error(
          'InternetConnectionSubscription',
          error: error,
          stackTrace: stackTrace,
        );
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
    _internetConnectionSubscription.pause();
  }

  @override
  void resumeStream() {
    _internetConnectionSubscription.resume();
  }

  @override
  void dispose() {
    _clearInactiveStreams();
    if (_listenerStreamList.isEmpty) {
      _internetConnectionSubscription.cancel();
    }
  }
}
