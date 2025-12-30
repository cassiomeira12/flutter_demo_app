// import 'package:flutter_demo_app/core/core.dart';

// import 'package:flutter_demo_app/design_system/design_system.dart';
// import 'package:flutter_demo_app/presentation/emergency/emergency_controller.dart';

// class EmergencyPage extends AppView<EmergencyController> {
//   const EmergencyPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldWidget(
//       controller: controller,
//       title: 'emergency'.tr,
//       body: ScrollViewWidget(child: (scrollController) {
//         return SingleChildScrollView(
//           controller: scrollController,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             spacing: 10,
//             children: [
//               PrimaryButton(
//                 text: 'ButtonSize.large',
//                 onPressed: () {},
//               ),
//               PrimaryButton(
//                 text: 'ButtonSize.medium',
//                 size: ButtonSize.medium,
//                 onPressed: () {},
//               ),
//               PrimaryButton(
//                 text: 'ButtonSize.small',
//                 size: ButtonSize.small,
//                 onPressed: () {},
//               ),
//               SecondaryButton(
//                 text: 'SecondaryButton.large',
//                 onPressed: () {},
//               ),
//               SecondaryButton(
//                 text: 'SecondaryButton.medium',
//                 size: ButtonSize.medium,
//                 onPressed: () {},
//               ),
//               SecondaryButton(
//                 text: 'SecondaryButton.small',
//                 size: ButtonSize.small,
//                 onPressed: () {},
//               ),
//               ToggleButton(
//                 text: 'ToggleButton',
//                 value: false,
//                 onPressed: (value) {},
//               ),
//               LightButton(
//                 text: 'LightButton',
//                 onPressed: () {},
//               ),
//               TextWidget(
//                 'title',
//                 style: AppTextStyle.title(context),
//               ),
//               TextWidget(
//                 'subtitle',
//                 style: AppTextStyle.subtitle(context),
//               ),
//               TextWidget(
//                 'message',
//                 style: AppTextStyle.message(context),
//               ),
//               TextWidget(
//                 'label',
//                 style: AppTextStyle.label(context),
//               ),
//               TextWidget(
//                 'button',
//                 style: AppTextStyle.button(context),
//               ),
//               TextWidget(
//                 'hyperlink',
//                 style: AppTextStyle.hyperlink(context),
//               ),
//               TextWidget(
//                 'footnote',
//                 style: AppTextStyle.footnote(context),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
