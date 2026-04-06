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
        Log.error(error, stackTrace, msg: 'InternetConnectionSubscription');
      },
    );
  }

  InternetStatus? _lastStatus;

  final _listenerStreamList = List<StreamController<bool>>.empty(
    growable: true,
  );

  static Timer? _onListenerChangeTimer;

  void _listenChangeStatus(InternetStatus status) {
    _clearInactiveStreams();
    if (_onListenerChangeTimer?.isActive ?? false) {
      _onListenerChangeTimer?.cancel();
    }
    _onListenerChangeTimer = Timer(const Duration(seconds: 1), () {
      if (_lastStatus != null && _lastStatus != status) {
        Log.debug('Change internet connection status [${status.name}]');
        for (final streamController in _listenerStreamList) {
          streamController.add(status == InternetStatus.connected);
        }
      }
      _lastStatus = status;
    });
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
  Future<bool> hasInternetAccess() => _internetConnection.hasInternetAccess;

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
