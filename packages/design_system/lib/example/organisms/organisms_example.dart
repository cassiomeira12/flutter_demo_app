import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

part 'example_routes.dart';

class ExampleOrganismsPage extends StatelessWidget {
  const ExampleOrganismsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisms Widgets'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTile(
            context,
            'Scaffold',
            ExampleOrganismsRoutes.scaffold.route,
          ),
          const Divider(),
          _buildTile(context, 'AppBar', ExampleOrganismsRoutes.app_bar.route),
          const Divider(),
          _buildTile(context, 'Dialog', ExampleOrganismsRoutes.dialog.route),
          const Divider(),
          _buildTile(
            context,
            'BottomSheet',
            ExampleOrganismsRoutes.bottom_sheet.route,
          ),
          const Divider(),
          _buildTile(
            context,
            'SnackBar',
            ExampleOrganismsRoutes.snack_bar.route,
          ),
          const Divider(),
          _buildTile(context, 'Drawer', ExampleOrganismsRoutes.drawer.route),
          const Divider(),
          _buildTile(context, 'Captcha', ExampleOrganismsRoutes.captcha.route),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}

class ExampleScaffoldPage extends StatelessWidget {
  const ExampleScaffoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scaffold Example'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Scaffold Widget Example'),
      ),
    );
  }
}

class ExampleAppBarPage extends StatelessWidget {
  const ExampleAppBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Example'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('AppBar Widget Example'),
      ),
    );
  }
}

class ExampleDialogPage extends StatelessWidget {
  const ExampleDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialog'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showDialog(context),
          child: const Text('Mostrar Dialog'),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    // showDialog(
    //   context: context,
    //   builder: (context) => DialogWidget.show(
    //     context,
    //     title: 'Título do Dialog',
    //     content: const Text('Conteúdo do dialog aqui.'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: const Text('Cancelar'),
    //       ),
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: const Text('Confirmar'),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class ExampleBottomSheetPage extends StatelessWidget {
  const ExampleBottomSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomSheet'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showBottomSheet(context),
          child: const Text('Mostrar Bottom Sheet'),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    // showModalBottomSheet(
    //   context: context,
    //   builder: (context) => const BottomSheetWidget(
    //     title: 'Título',
    //     content: Text('Conteúdo'),
    //   ),
    // );
  }
}

class ExampleSnackBarPage extends StatelessWidget {
  const ExampleSnackBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnackBar'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showSnackBar(context),
          child: const Text('Mostrar SnackBar'),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBarWidget(
    //     content: const Text('Mensagem de exemplo'),
    //     action: SnackBarAction(
    //       label: 'Desfazer',
    //       onPressed: () {},
    //     ),
    //   ),
    // );
  }
}

class ExampleDrawerPage extends StatelessWidget {
  const ExampleDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer'),
        centerTitle: true,
      ),
      drawer: DrawerWebWidget(
        children: [
          const DrawerHeader(
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('Abra o drawer pelo ícone à esquerda'),
      ),
    );
  }
}

class ExampleCaptchaPage extends StatelessWidget {
  const ExampleCaptchaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captcha'),
        centerTitle: true,
      ),
      body: Center(
        child: CaptchaWidget(
          onSuccess: () {},
        ),
      ),
    );
  }
}
