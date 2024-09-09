import 'package:get/get.dart';

import '../../design_system/design_system.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      showBackButtonOnWeb: true,
      controller: controller,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                'Title',
                style: AppTextStyle.title(context),
              ),
              TextWidget(
                'Subtitle',
                style: AppTextStyle.subtitle(context),
              ),
              TextWidget(
                'Message',
                style: AppTextStyle.message(context),
              ),
              TextWidget(
                'Label',
                style: AppTextStyle.label(context),
              ),
              TextWidget(
                'Field',
                style: AppTextStyle.field(context),
              ),
              TextWidget(
                'Button',
                style: AppTextStyle.button(context),
              ),
              TextWidget(
                'Hyperlink',
                style: AppTextStyle.hyperlink(context),
              ),
              TextWidget(
                'Footnote',
                style: AppTextStyle.footnote(context),
              ),
              CircularProgressIndicator(),
              PrimaryButton(
                text: 'Light',
                icon: FlutterIcon(Icons.arrow_back_ios),
                onPressed: () {
                  controller.teste('light');
                },
              ),
              PrimaryButton(
                text: 'Dark',
                icon: FlutterIcon(Icons.arrow_back_ios),
                onPressed: () {
                  controller.teste('dark');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
