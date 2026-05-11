import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class EmergencyServiceImpl implements EmergencyService {
  final EmergencyDataSource _dataSource;

  EmergencyServiceImpl({
    required EmergencyDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _dataSource.isAvailable();
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      throw BaseException();
    }
  }

  @override
  Future<int> sendSOS({
    required int choice,
    required double latitude,
    required double longitude,
    required int accuracy,
  }) async {
    try {
      return await _dataSource.sendSOS(
        choice: choice,
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy,
      );
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      throw BaseException();
    }
  }

  @override
  Future<List<OccurrenceEntity>> listHistory() async {
    try {
      final List<Map<String, dynamic>> result = await _dataSource.listHistory();

      final List<OccurrenceModel> occurrencies = result.map((json) {
        return OccurrenceModel.fromMap(json);
      }).toList();

      return occurrencies;
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      throw BaseException();
    }
  }

  @override
  Future<SosConfigEntity> changeSOSConfig({
    required bool onlyPolice,
    required bool onlySafetyContacts,
  }) async {
    try {
      final Map<String, dynamic> result = await _dataSource.changeSOSConfig(
        onlyPolice: onlyPolice,
        onlySafetyContacts: onlySafetyContacts,
      );

      final SosConfigModel user = SosConfigModel.fromMap(result);

      return user;
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      throw BaseException();
    }
  }
}
