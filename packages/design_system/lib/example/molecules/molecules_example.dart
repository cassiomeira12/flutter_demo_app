import 'package:design_system/src/components/components.dart';
import 'package:flutter/material.dart';

part 'example_routes.dart';

class ExampleMoleculesPage extends StatelessWidget {
  const ExampleMoleculesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Molecules Widgets'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTile(context, 'Buttons', ExampleMoleculesRoutes.buttons.route),
          const Divider(),
          _buildTile(context, 'Inputs', ExampleMoleculesRoutes.inputs.route),
          const Divider(),
          _buildTile(
            context,
            'SwitchTitle',
            ExampleMoleculesRoutes.switch_title.route,
          ),
          const Divider(),
          _buildTile(
            context,
            'CheckboxTitle',
            ExampleMoleculesRoutes.checkbox_title.route,
          ),
          const Divider(),
          _buildTile(
            context,
            'ProgressBar',
            ExampleMoleculesRoutes.progress_bar.route,
          ),
          const Divider(),
          _buildTile(
            context,
            'Skeleton',
            ExampleMoleculesRoutes.skeleton.route,
          ),
          const Divider(),
          _buildTile(context, 'Effects', ExampleMoleculesRoutes.effects.route),
          const Divider(),
          _buildTile(
            context,
            'FloatingButton',
            ExampleMoleculesRoutes.floating_button.route,
          ),
          const Divider(),
          _buildTile(
            context,
            'IconButton',
            ExampleMoleculesRoutes.icon_button.route,
          ),
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

class ExampleButtonsPage extends StatelessWidget {
  const ExampleButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('PrimaryButton', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          const PrimaryButton(text: 'Primary'),
          const SizedBox(height: 12),
          const SecondaryButton(text: 'Secondary'),
          const SizedBox(height: 12),
          const FlatButton(text: 'Flat'),
          const SizedBox(height: 12),
          const LightButton(text: 'Light'),
          const SizedBox(height: 24),
          Text('Sizes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          const PrimaryButton(text: 'Large'),
          const SizedBox(height: 8),
          const PrimaryButton(text: 'Medium', size: ButtonSize.medium),
          const SizedBox(height: 8),
          const PrimaryButton(text: 'Small', size: ButtonSize.small),
        ],
      ),
    );
  }
}

class ExampleInputsPage extends StatelessWidget {
  const ExampleInputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inputs'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'TextFieldWidget',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          TextFieldWidget(label: 'Nome'),
          const SizedBox(height: 24),
          Text(
            'TextAreaFieldWidget',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const TextAreaFieldWidget(label: 'Mensagem'),
          const SizedBox(height: 24),
          Text(
            'PhoneFieldWidget',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const PhoneFieldWidget(label: 'Telefone'),
          const SizedBox(height: 24),
          Text(
            'PinFieldWidget',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const PinFieldWidget(pinLength: 4),
        ],
      ),
    );
  }
}

class ExampleSwitchTitlePage extends StatefulWidget {
  const ExampleSwitchTitlePage({super.key});

  @override
  State<ExampleSwitchTitlePage> createState() => _ExampleSwitchTitlePageState();
}

class _ExampleSwitchTitlePageState extends State<ExampleSwitchTitlePage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SwitchTitleWidget'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchTitleWidget(
            text: 'Notificações',
            initialValue: _value,
            onChanged: (value) => setState(() => _value = value),
          ),
        ],
      ),
    );
  }
}

class ExampleCheckboxTitlePage extends StatefulWidget {
  const ExampleCheckboxTitlePage({super.key});

  @override
  State<ExampleCheckboxTitlePage> createState() =>
      _ExampleCheckboxTitlePageState();
}

class _ExampleCheckboxTitlePageState extends State<ExampleCheckboxTitlePage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckboxTitleWidget'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxTitleWidget(
            text: 'Aceito os termos',
            initialValue: _value,
            onChanged: (value) => setState(() => _value = value),
          ),
        ],
      ),
    );
  }
}

class ExampleProgressBarPage extends StatelessWidget {
  const ExampleProgressBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProgressBarWidget'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'ProgressBarWidget',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const ProgressBarWidget(percentage: 0.5),
          const SizedBox(height: 24),
          Text(
            'ProgressStepBarWidget',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const ProgressStepBarWidget(currentIndex: 2, percentage: 4),
        ],
      ),
    );
  }
}

class ExampleSkeletonPage extends StatelessWidget {
  const ExampleSkeletonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkeletonWidget'),
        centerTitle: true,
      ),
      body: const SkeletonWidget(),
    );
  }
}

class ExampleEffectsPage extends StatelessWidget {
  const ExampleEffectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Effects'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'BlurEffectWidget',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Container(
            color: Colors.grey,
            padding: const EdgeInsets.all(20),
            child: const BlurEffectWidget(
              enabled: true,
              ignorePointer: true,
              child: Text('Blur Effect'),
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleFloatingButtonPage extends StatelessWidget {
  const ExampleFloatingButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FloatingButtonWidget'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Clique no botão flutuante',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingButtonWidget(
              icon: const FlutterIcon(Icons.add),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleIconButtonPage extends StatelessWidget {
  const ExampleIconButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IconButtonWidget'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          IconButtonWidget(
            icon: const FlutterIcon(Icons.home),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          IconButtonWidget(
            icon: const FlutterIcon(Icons.settings),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          IconButtonWidget(
            icon: const FlutterIcon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
