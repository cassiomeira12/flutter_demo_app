import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UnknownPage extends AppView<UnknownController> {
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: '',
      controller: controller,
      body: const Center(child: TextWidget('Página não encontrada')),
    );
  }
}
