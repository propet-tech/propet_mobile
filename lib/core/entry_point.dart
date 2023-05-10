import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/auth/auth_service.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/models/userinfo.dart';
import 'package:provider/provider.dart';

class ScaffoldWithNavBarTabItem extends BottomNavigationBarItem {
  final String initialLocation;
  final String title;

  const ScaffoldWithNavBarTabItem(
      {required this.initialLocation,
      required Widget icon,
      String? label,
      required this.title})
      : super(icon: icon, label: label);
}

class ScaffoldNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldNavBar({super.key, required this.child});

  @override
  State<ScaffoldNavBar> createState() => _ScaffoldNavBarState();
}

class _ScaffoldNavBarState extends State<ScaffoldNavBar> {
  final tabs = [
    const ScaffoldWithNavBarTabItem(
      icon: Icon(
        Icons.home,
      ),
      label: "Home",
      title: "Home",
      initialLocation: "/home",
    ),
    const ScaffoldWithNavBarTabItem(
      icon: Icon(
        Icons.pets,
      ),
      title: "Meus Pets",
      label: "Pets",
      initialLocation: "/pets",
    ),
    const ScaffoldWithNavBarTabItem(
      icon: Icon(
        Icons.shopping_bag,
      ),
      title: "Meus Pedidos",
      label: "Pedidos",
      initialLocation: "/orders",
    ),
  ];

  int get currentIndex => locationToIndex(GoRouter.of(context).location);

  int locationToIndex(String location) {
    final index =
        tabs.indexWhere((t) => location.startsWith(t.initialLocation));
    return index < 0 ? 0 : index;
  }

  void onTap(int index) {
    if (index != currentIndex) {
      context.go(tabs[index].initialLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userinfo = context.read<UserInfo>();

    final picture = NetworkImage(userinfo.picture!);

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: picture,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(userinfo.name ?? "Sem Nome"),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    getIt<AuthService>().logout();
                  },
                  label: Text("Sair"),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.settings),
                  onPressed: () {},
                  label: Text("Configurações"),
                )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              child: Container(
                margin: const EdgeInsets.all(6),
                child: CircleAvatar(
                  backgroundImage: picture,
                ),
              ),
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: true,
        title: Text(tabs[currentIndex].title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.background,
        selectedItemColor: Theme.of(context).colorScheme.background,
        items: tabs,
        onTap: (value) {
          onTap(value);
        },
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: widget.child,
          );
        },
      ),
    );
  }
}
