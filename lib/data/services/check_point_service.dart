import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class CheckPointServiceImpl implements CheckPointService {
  final CheckPointDataSource _checkPointDataSource;

  CheckPointServiceImpl({required this._checkPointDataSource});

  @override
  Future<List<CheckDayPointEntity>> currentPoints({
    required int month,
    required int year,
  }) async {
    try {
      final List<Map<String, dynamic>> result = await _checkPointDataSource
          .currentPoints(
            month: month,
            year: year,
          );

      final List<CheckDayPointModel> checkPoints = result.map((json) {
        return CheckDayPointModel.fromMap(json);
      }).toList();

      return checkPoints;
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> registerPoint() async {
    try {
      return await _checkPointDataSource.registerPoint();
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<String> totalHours({
    required int month,
    required int year,
  }) async {
    try {
      return await _checkPointDataSource.totalHours(
        month: month,
        year: year,
      );
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }
}
