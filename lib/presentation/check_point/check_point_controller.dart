import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/check_points/check_points_controller.dart';
import 'package:flutter_demo_app/presentation/check_points/check_points_store.dart';

class CheckPointController extends BaseController {
  final UpdateWorkDayUseCase _updateWorkDayUseCase;
  final UpdateHourPointUseCase _updateHourPointUseCase;
  final DeleteHourPointUseCase _deleteHourPointUseCase;
  final RegisterCustomPointUseCase _registerCustomPointUseCase;
  final CheckPointsController _checkPointsController;
  final CheckPointsStore _checkPointsStore;

  CheckPointController({
    required this._updateWorkDayUseCase,
    required this._updateHourPointUseCase,
    required this._deleteHourPointUseCase,
    required this._registerCustomPointUseCase,
    required this._checkPointsController,
    required this._checkPointsStore,
  });

  final RxBool loading = RxBool(false);

  CheckDayPointEntity? get checkPointDay {
    return _checkPointsStore.checkPointDaySelected;
  }

  String get dateFormatted => checkPointDay?.dateFormatted ?? '--/--/--';

  List<CheckHourPointEntity> get points => checkPointDay?.points ?? [];

  @override
  void onClose() {
    loading.close();
    super.onClose();
  }

  Future<void> updateCheckDayPoint({
    bool? allowance,
    bool? holiday,
    bool? dayOff,
    required String info,
  }) async {
    loading.value = true;
    try {
      final CheckDayPointEntity result = await _updateWorkDayUseCase.call(
        day: checkPointDay!.day,
        month: checkPointDay!.month,
        year: checkPointDay!.year,
        allowance: allowance ?? checkPointDay!.isAllowance,
        holiday: holiday ?? checkPointDay!.isHoliday,
        dayOff: dayOff ?? checkPointDay!.isDayOff,
        info: info,
      );
      _checkPointsStore.checkPointDaySelected = result;
      _checkPointsController.getCurrentCheckPoints();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateCheckHourPoint(
    CheckHourPointEntity checkHour, {
    required int hour,
    required int minute,
  }) async {
    loading.value = true;
    try {
      final String hourLabel = _addLeadingZeroIfNeeded(hour);
      final String minuteLabel = _addLeadingZeroIfNeeded(minute);
      final String time = '$hourLabel:$minuteLabel';
      final CheckDayPointEntity result = await _updateHourPointUseCase.call(
        checkHourPoint: checkHour,
        time: time,
      );
      _checkPointsStore.checkPointDaySelected = result;
      _checkPointsController.getCurrentCheckPoints();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteCheckHourPoint(CheckHourPointEntity checkHour) async {
    loading.value = true;
    try {
      final CheckDayPointEntity result = await _deleteHourPointUseCase.call(
        checkHour,
      );
      _checkPointsStore.checkPointDaySelected = result;
      _checkPointsController.getCurrentCheckPoints();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<void> registerCustomPoint({
    required int hour,
    required int minute,
  }) async {
    loading.value = true;
    try {
      final String hourLabel = _addLeadingZeroIfNeeded(hour);
      final String minuteLabel = _addLeadingZeroIfNeeded(minute);
      final String time = '$hourLabel:$minuteLabel';
      final CheckDayPointEntity result = await _registerCustomPointUseCase.call(
        day: checkPointDay!.day,
        month: checkPointDay!.month,
        year: checkPointDay!.year,
        time: time,
      );
      _checkPointsStore.checkPointDaySelected = result;
      _checkPointsController.getCurrentCheckPoints();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }
}
