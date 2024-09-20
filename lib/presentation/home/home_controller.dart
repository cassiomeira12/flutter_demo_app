import '../../core/core.dart';

class HomeController extends BaseController {
  RxInt selectedIndex = RxInt(0);

  void changeTab(int index) {
    if (selectedIndex.value == index) return;
    switch (index) {
      case 0:
        selectedIndex.value = index;
        break;
      case 1:
        selectedIndex.value = index;
        break;
      case 2:
        selectedIndex.value = index;
        break;
    }
  }
}
