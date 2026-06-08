import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class InternetConnectionServiceImpl implements InternetConnectionService {
  late final InternetConnection _internetConnection;

  InternetConnectionServiceImpl() {
    _internetConnection = InternetConnection.createInstance();
    _connectInternetSubscription();
  }

  StreamSubscription<InternetStatus>? _listenerSubscription;

  InternetStatus? _lastStatus;
  final _listenerStreamList = List<StreamController<bool>>.empty(
    growable: true,
  );
  Timer? _multipleIgnoreCallsTimer;
  final delayToOverrideCurrentStatus = const Duration(seconds: 1);

  void _connectInternetSubscription() {
    _listenerSubscription = _internetConnection.onStatusChange.listen(
      _onStatusChanged,
      onDone: () {
        _listenerSubscription?.cancel();
        _listenerSubscription = null;
        _lastStatus = null;
      },
      onError: (Object error) {
        _listenerSubscription?.cancel();
        _listenerSubscription = null;
        _lastStatus = null;
        Log.error(error, null, msg: 'InternetConnectionSubscription');
      },
    );
  }

  void _onStatusChanged(InternetStatus status) {
    if (_multipleIgnoreCallsTimer?.isActive ?? false) {
      _multipleIgnoreCallsTimer?.cancel();
    }
    _multipleIgnoreCallsTimer = Timer(delayToOverrideCurrentStatus, () {
      _listenerStreamList.removeWhere((stream) => stream.isClosed);
      if (_lastStatus != null /*&& _lastStatus != status*/ ) {
        if (status == InternetStatus.connected) {
          Log.success('Change internet connection status [${status.name}]');
        } else {
          Log.warning('Change internet connection status [${status.name}]');
        }
        for (final streamController in _listenerStreamList) {
          if (!streamController.isClosed) {
            streamController.add(status == InternetStatus.connected);
          }
        }
      }
      _lastStatus = status;
    });
  }

  @override
  void addStream(StreamController<bool> streamController) {
    if (streamController.isClosed) return;
    _listenerStreamList.add(streamController);
    if (_lastStatus != null) {
      streamController.add(_lastStatus == InternetStatus.connected);
    }
  }

  @override
  Future<bool> hasInternetAccess() async {
    try {
      return await _internetConnection.hasInternetAccess;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return false;
    }
  }

  @override
  void pauseStream() {
    _listenerSubscription?.pause();
  }

  @override
  void resumeStream() {
    _listenerSubscription?.resume();
    if (_listenerSubscription == null) {
      _connectInternetSubscription();
    }
  }

  @override
  void dispose() {
    _multipleIgnoreCallsTimer?.cancel();
    _listenerStreamList.forEach((stream) {
      try {
        if (!stream.isClosed) {
          stream.close();
        }
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
      }
    });
    _listenerSubscription?.cancel();
  }
}
