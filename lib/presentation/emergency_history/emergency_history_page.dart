import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/presentation/emergency_history/emergency_history.dart';

class EmergencyHistoryPage extends AppView<EmergencyHistoryController> {
  const EmergencyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'emergency_history'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveSizeHelper.width(20),
              ),
              child: const Column(
                children: [
                  SpacerWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
