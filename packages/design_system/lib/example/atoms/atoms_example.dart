import 'package:design_system/src/components/components.dart';
import 'package:flutter/material.dart';

part 'example_routes.dart';

class ExampleAtomsPage extends StatelessWidget {
  const ExampleAtomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atoms Widgets'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTile(context, 'TextWidget', ExampleAtomsRoutes.text.route),
          const Divider(),
          _buildTile(context, 'IconsWidget', ExampleAtomsRoutes.icons.route),
          const Divider(),
          _buildTile(
            context,
            'SwitchWidget',
            ExampleAtomsRoutes.switch_example.route,
          ),
          const Divider(),
          _buildTile(
            context,
            'CheckboxWidget',
            ExampleAtomsRoutes.checkbox.route,
          ),
          const Divider(),
          _buildTile(
            context,
            'LoadingWidget',
            ExampleAtomsRoutes.loading.route,
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

class ExampleTextPage extends StatelessWidget {
  const ExampleTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextWidget'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Title Large',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Title Medium',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Title Small',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Body Large',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Body Medium',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Body Small',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Label Large',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Label Medium',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Label Small',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class ExampleIconsPage extends StatelessWidget {
  const ExampleIconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icons'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('FlutterIcon', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FlutterIcon(Icons.home, size: IconSize.medium),
              FlutterIcon(Icons.settings, size: IconSize.medium),
              FlutterIcon(Icons.search, size: IconSize.medium),
              FlutterIcon(Icons.favorite, size: IconSize.medium),
              FlutterIcon(Icons.person, size: IconSize.medium),
              FlutterIcon(Icons.star, size: IconSize.medium),
              FlutterIcon(Icons.add, size: IconSize.medium),
              FlutterIcon(Icons.edit, size: IconSize.medium),
              FlutterIcon(Icons.delete, size: IconSize.medium),
              FlutterIcon(Icons.share, size: IconSize.medium),
            ],
          ),
          const SizedBox(height: 24),
          Text('AppIcon', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppIcon(AppIcons.logo, size: IconSize.medium),
              AppIcon(AppIcons.maintenance, size: IconSize.medium),
              AppIcon(AppIcons.bell, size: IconSize.medium),
            ],
          ),
        ],
      ),
    );
  }
}

class ExampleSwitchPage extends StatefulWidget {
  const ExampleSwitchPage({super.key});

  @override
  State<ExampleSwitchPage> createState() => _ExampleSwitchPageState();
}

class _ExampleSwitchPageState extends State<ExampleSwitchPage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SwitchWidget'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Value: $_value',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Center(
            child: SwitchWidget(
              value: _value,
              onChanged: (value) => setState(() => _value = value),
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleCheckboxPage extends StatefulWidget {
  const ExampleCheckboxPage({super.key});

  @override
  State<ExampleCheckboxPage> createState() => _ExampleCheckboxPageState();
}

class _ExampleCheckboxPageState extends State<ExampleCheckboxPage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckboxWidget'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Value: $_value',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Center(
            child: CheckboxWidget(
              value: _value,
              onChanged: (value) => setState(() => _value = value),
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleLoadingPage extends StatelessWidget {
  const ExampleLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CircularLoadingWidget'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(child: CircularLoadingWidget()),
          const SizedBox(height: 24),
          Text(
            'Custom Color',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const Center(
            child: CircularLoadingWidget(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
