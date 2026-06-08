import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class WorkPointAuthTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppBinding.hasInstance<SessionEntity>()) {
      final session = AppBinding.find<SessionEntity>();
      if (session.isAuthenticated) {
        options.headers.addAll({'Authorization': 'Bearer ${session.token}'});
      }
    }
    super.onRequest(options, handler);
  }
}
