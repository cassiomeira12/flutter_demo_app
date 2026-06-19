import 'package:app_purchase/src/data/data.dart';
import 'package:app_purchase/src/data/models/available_purchase_model.dart';
import 'package:app_purchase/src/domain/domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AvailablePurchaseProductServiceImpl
    implements AvailablePurchaseProductService {
  final AvailablePurchaseProductDataSource _availablePurchaseProductDataSource;

  AvailablePurchaseProductServiceImpl({
    required this._availablePurchaseProductDataSource,
  });

  @override
  Future<List<AvailablePurchaseEntity>> list() async {
    try {
      final List<Map<String, dynamic>> result =
          await _availablePurchaseProductDataSource.list();
      final List<AvailablePurchaseModel> listData = [];

      for (final json in result) {
        try {
          listData.add(AvailablePurchaseModel.fromMap(json));
        } on BaseException catch (error) {
          Log.baseException(error);
        }
      }

      return listData;
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }
}
