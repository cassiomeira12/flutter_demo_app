import 'package:core/core.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';

class SafetyContactServiceImpl implements SafetyContactService {
  final SafetyContactDataSource _dataSource;

  SafetyContactServiceImpl({
    required SafetyContactDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<SafetyContactModel> create({
    required String name,
    required String phoneNumber,
    required bool sendMessage,
  }) async {
    try {
      final Map<String, dynamic> result = await _dataSource.create(
        name: name,
        phoneNumber: phoneNumber,
        sendMessage: sendMessage,
      );

      final SafetyContactModel safetyContact = SafetyContactModel.fromMap(
        result,
      );

      return safetyContact;
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      throw BaseException();
    }
  }

  @override
  Future<List<SafetyContactModel>> list(int page) async {
    try {
      final List<Map<String, dynamic>> result = await _dataSource.list(page);

      final List<SafetyContactModel> safetyContacts = result.map((item) {
        return SafetyContactModel.fromMap(item);
      }).toList();

      return safetyContacts;
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      throw BaseException();
    }
  }

  @override
  Future<bool> delete(String objectId) {
    return _dataSource.delete(objectId);
  }
}
