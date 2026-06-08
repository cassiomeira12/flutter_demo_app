import 'package:clean_code_data/clean_code_data.dart';

class WorkPointLogoutDataSource implements LogoutDataSource {
  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
