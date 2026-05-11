import 'package:core/core.dart';

class WorkPointLogoutDataSource implements LogoutDataSource {
  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
