import 'package:admin/src/presentation/web_visit_history/web_visit_history.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class WebVisitHistoryBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<WebVisitHistoryController>(
      WebVisitHistoryController(
        listWebVisitHistoryUseCase: AppBinding.find(),
      ),
    );
  }
}
