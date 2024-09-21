import 'package:flutter/widgets.dart';

import '../../core/core.dart';
import '../../domain/entities/session_entity.dart';
import '../app_router.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      final sessionEntity = AppBinding.get<SessionEntity>();
      assert(sessionEntity.token != null);
      return null;
    } catch (_) {
      return RouteSettings(name: AppRouter.login.name);
    }
  }
}
