import 'package:admin/src/presentation/admin_crud/admin_crud.dart';
import 'package:admin/src/presentation/admin_crud/admin_crud_list_page.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AdminCrudPage extends AppView<AdminCrudController> {
  const AdminCrudPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Crud'.tr,
      controller: controller,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(20)),
              child: Column(
                spacing: ResponsiveSizeHelper.spacingDefaultHeight,
                children: [
                  ...controller.crudMap.map((map) {
                    return SecondaryButton(
                      expandWidth: true,
                      text: map['title'],
                      onPressed: () {
                        AppNavigator.to(() => map['page'] as AdminCrudListPage);
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
