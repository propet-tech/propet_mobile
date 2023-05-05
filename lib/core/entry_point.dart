import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Container(
            margin: const EdgeInsets.all(6),
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/kasane-teto.gif"),
            ),
          ),
          onTap: () {},
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
