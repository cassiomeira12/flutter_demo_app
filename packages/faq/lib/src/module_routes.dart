import 'package:core/core.dart';
import 'package:faq/src/presentation/presentation.dart';

class FaqModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.about.name,
      page: AboutPage.new,
      binding: AboutBindings(),
    ),
    AppRouterPage(
      name: AppRouter.feedback.name,
      page: FeedbackPage.new,
      binding: FeedbackBindings(),
    ),
  ];
}
