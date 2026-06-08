import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:web_app/src/presentation/web/web.dart';

class AppCardWidget extends AppView<WebController> {
  const AppCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppAssets.main),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
