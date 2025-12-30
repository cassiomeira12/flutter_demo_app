import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ParseServerAuthTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppBinding.hasInstance<SessionEntity>()) {
      final session = AppBinding.find<SessionEntity>();
      if (session.token != null) {
        options.headers.addAll({'X-Parse-Session-Token': session.token});
      }
    }
    super.onRequest(options, handler);
  }
}
