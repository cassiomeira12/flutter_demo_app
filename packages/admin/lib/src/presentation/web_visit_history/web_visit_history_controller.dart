import 'package:core/core.dart';

class WebVisitHistoryController
    extends ListenableBaseController<WebVisitHistoryEntity> {
  final ListWebVisitHistoryUseCase _listWebVisitHistoryUseCase;

  WebVisitHistoryController({
    required ListWebVisitHistoryUseCase listWebVisitHistoryUseCase,
  }) : _listWebVisitHistoryUseCase = listWebVisitHistoryUseCase;

  @override
  Future<List<WebVisitHistoryEntity>> Function() get fetchDataFunction {
    return _listWebVisitHistoryUseCase.call;
  }

  void refreshWebVisitHistory() {
    clickTagging(component: 'web_visit_history_update_popup_menu_item_key');
    onFetchListData();
  }
}
