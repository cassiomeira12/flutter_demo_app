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
    } on HttpException catch (error) {
      throw ExceptionHelper.call(error);
    } catch (error, stacktrace) {
      Log.error(error.toString(), error: error, stackTrace: stacktrace);
      throw BaseException();
    }
  }
}
