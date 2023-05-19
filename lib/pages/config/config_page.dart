import 'package:flutter/material.dart';
import 'package:propet_mobile/core/app_config_provider.dart';
import 'package:provider/provider.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  void setTheme(BuildContext ctx,ThemeMode mode) {
    var appConfig = ctx.read<AppConfig>();

    if (appConfig.mode != mode) {
      appConfig.changeTheme(mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mode = context.watch<AppConfig>().mode;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          ConfigSection(
            title: const Text("Tema"),
            children: [
              ThemeConfigTile(
                icon: Icons.dark_mode,
                label: "Tema Escuro",
                onChanged: (value) => setTheme(context, ThemeMode.dark),
                value: mode == ThemeMode.dark,
              ),
              ThemeConfigTile(
                icon: Icons.light_mode,
                label: "Tema Claro",
                onChanged: (value) => setTheme(context, ThemeMode.light),
                value: mode == ThemeMode.light,
              ),
              ThemeConfigTile(
                icon: Icons.smartphone,
                label: "Padrão do sistema",
                onChanged: (value) => setTheme(context, ThemeMode.system),
                value: mode == ThemeMode.system,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ConfigSection extends StatelessWidget {
  final Widget title;
  final List<Widget> children;

  const ConfigSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: DefaultTextStyle(
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
              child: title,
            ),
          ),
          ...children
        ],
      ),
    );
  }
}

class ThemeConfigTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final void Function(bool? value) onChanged;

  const ThemeConfigTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label),
          ),
          Checkbox(
            value: value,
            shape: const CircleBorder(),
            onChanged: (value) => onChanged(value),
          ),
        ],
      ),
    );
  }
}
