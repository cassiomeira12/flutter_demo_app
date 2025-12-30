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
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } on Exception catch (_) {
      throw BaseException();
    }
  }

  @override
  Future<void> registerPoint() async {
    try {
      return await _dataSource.registerPoint();
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } on Exception catch (_) {
      throw BaseException();
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
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } on Exception catch (_) {
      throw BaseException();
    }
  }
}
