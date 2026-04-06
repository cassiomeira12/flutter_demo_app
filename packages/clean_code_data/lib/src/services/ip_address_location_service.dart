import 'package:core/core.dart';

class IpAddressLocationServiceImpl implements IpAddressLocationService {
  final IpAddressLocationDataSource _dataSource;

  IpAddressLocationServiceImpl({
    required IpAddressLocationDataSource ipAddressLocationDataSource,
  }) : _dataSource = ipAddressLocationDataSource;

  @override
  Future<IpAddressLocationEntity> getIpAddress({String? ip}) async {
    try {
      final Map<String, dynamic> result = await _dataSource.getIpAddress(
        ip: ip,
      );

      final model = IpAddressLocationModel.fromMap(result);

      return model;
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
