import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/app_state.dart';
import 'package:propet_mobile/core/components/profile_picture.dart';
import 'package:propet_mobile/environment.dart';
import 'package:propet_mobile/models/userinfo/userinfo.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> logout(BuildContext context) async {
    await context.read<AppState>().logout();
  }

  Future<void> openProfile() async {
    await launch("${AppEnvironment.issuerUrl}/account");
  }

  @override
  Widget build(BuildContext context) {
    final userinfo = context.read<AppState>().userinfo!;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AppDrawerHeader(userinfo: userinfo),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                ElevatedButtonSecondaryColor(
                  label: "Meu Perfil",
                  icon: Icons.launch,
                  onPressed: openProfile,
                ),
                const SizedBox(height: 10),
                ElevatedButtonSecondaryColor(
                  label: "Configurações",
                  icon: Icons.settings,
                  onPressed: () {
                    context.push("/config");
                  },
                ),
                const SizedBox(height: 10),
                ElevatedLoadButton(
                  label: "Sair",
                  icon: Icons.logout,
                  onPressed: () => logout(context),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _AppDrawerHeader extends StatelessWidget {
  final UserInfo userinfo;

  const _AppDrawerHeader({
    required this.userinfo,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ProfilePicture(userInfo: userinfo),
          ),
          const SizedBox(height: 8),
          Text(userinfo.name)
        ],
      ),
    );
  }
}

class ElevatedButtonSecondaryColor extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function() onPressed;

  const ElevatedButtonSecondaryColor({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      icon: Icon(icon),
      onPressed: onPressed,
      label: Text(label),
    );
  }
}

class ElevatedLoadButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Future<void> Function() onPressed;

  const ElevatedLoadButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    // required this.future,
  });

  @override
  State<ElevatedLoadButton> createState() => _ElevatedLoadButtonState();
}

class _ElevatedLoadButtonState extends State<ElevatedLoadButton> {
  bool loading = false;
  final _statesController = MaterialStatesController();

  void onPressed() {
    setState(() {
      loading = true;
      _statesController.update(MaterialState.disabled, true);
    });
    widget.onPressed().whenComplete(() => setState(() {
          loading = false;
          _statesController.update(MaterialState.disabled, false);
        }));
  }

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.textScaleFactorOf(context);
    final double gap = scale <= 1 ? 8 : lerpDouble(8, 4, min(scale - 1, 1))!;
    final List<Widget> rowChildren;

    if (!loading) {
      rowChildren = [
        Icon(widget.icon),
        SizedBox(width: gap),
        Text(widget.label)
      ];
    } else {
      rowChildren = [
        SizedBox(
          height: IconTheme.of(context).size,
          width: IconTheme.of(context).size,
          child: const CircularProgressIndicator(),
        ),
      ];
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      onPressed: onPressed,
      statesController: _statesController,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: rowChildren,
      ),
    );
  }
}
