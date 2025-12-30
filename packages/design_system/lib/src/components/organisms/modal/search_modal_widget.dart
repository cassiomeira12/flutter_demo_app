import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class SearchModalWidget extends StatelessWidget {
  const SearchModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldWidget(
            label: 'search'.tr,
            onSearch: (String search) {
              //
            },
          ),
        ],
      ),
    );
  }
}
