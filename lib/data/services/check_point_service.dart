import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CheckPointServiceImpl implements CheckPointService {
  final CheckPointDataSource _dataSource;

  CheckPointServiceImpl({
    required CheckPointDataSource checkPointDataSource,
  }) : _dataSource = checkPointDataSource;

  @override
  Future<List<CheckDayPointEntity>> currentPoints({
    required int month,
    required int year,
  }) async {
    try {
      final List<Map<String, dynamic>> result = await _dataSource.currentPoints(
        month: month,
        year: year,
      );

      final List<CheckDayPointModel> checkPoints = result.map((json) {
        return CheckDayPointModel.fromMap(json);
      }).toList();

      return checkPoints;
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error('currentPoints', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'currentPoints',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> registerPoint() async {
    try {
      return await _dataSource.registerPoint();
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error('registerPoint', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'registerPoint',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String> totalHours({
    required int month,
    required int year,
  }) async {
    try {
      return await _dataSource.totalHours(
        month: month,
        year: year,
      );
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error('totalHours', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'totalHours',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<CheckDayPointEntity> updateWorkDay({
    required int day,
    required int month,
    required int year,
    bool allowance = false,
    bool holiday = false,
    bool dayOff = false,
    required String info,
  }) async {
    try {
      final Map<String, dynamic> result = await _dataSource.updateWorkDay(
        day: day,
        month: month,
        year: year,
        allowance: allowance,
        holiday: holiday,
        dayOff: dayOff,
        info: info,
      );
      return CheckDayPointModel.fromMap(result);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error('updateWorkDay', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'updateWorkDay',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<CheckDayPointEntity> updateHourPoint(
    CheckHourPointEntity checkHourPoint, {
    required String time,
  }) async {
    try {
      final Map<String, dynamic> result = await _dataSource.updateWorkPoint(
        checkHourPoint.objectId,
        time: time,
      );
      return CheckDayPointModel.fromMap(result);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error('updateHourPoint', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'updateHourPoint',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<CheckDayPointEntity> deleteHourPoint(
    CheckHourPointEntity checkHourPoint,
  ) async {
    try {
      final Map<String, dynamic> result = await _dataSource.updateWorkPoint(
        checkHourPoint.objectId,
        time: null,
      );
      return CheckDayPointModel.fromMap(result);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error('deleteHourPoint', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'deleteHourPoint',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<CheckDayPointEntity> registerCustomPoint({
    required int day,
    required int month,
    required int year,
    required String time,
  }) async {
    try {
      final Map<String, dynamic> result = await _dataSource.registerCustomPoint(
        day: day,
        month: month,
        year: year,
        time: time,
      );
      return CheckDayPointModel.fromMap(result);
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      Log.error('registerCustomPoint', error: error, stackTrace: stackTrace);
      throw BaseException(
        message: 'registerCustomPoint',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
