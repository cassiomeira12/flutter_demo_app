import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class IpAddressLocationServiceImpl implements IpAddressLocationService {
  final IpAddressLocationDataSource _ipAddressLocationDataSource;

  IpAddressLocationServiceImpl({required this._ipAddressLocationDataSource});

  @override
  Future<IpAddressLocationEntity> getIpAddress({String? ip}) async {
    try {
      final result = await _ipAddressLocationDataSource.getIpAddress(ip: ip);
      return IpAddressLocationModel.fromMap(result);
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
