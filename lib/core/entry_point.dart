import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBarTabItem extends BottomNavigationBarItem {
  final String initialLocation;

  const ScaffoldWithNavBarTabItem(
      {required this.initialLocation, required Widget icon, String? label})
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
      initialLocation: "/a",
    ),
    const ScaffoldWithNavBarTabItem(
      icon: Icon(
        Icons.pets,
      ),
      label: "Pets",
      initialLocation: "/b",
    ),
    const ScaffoldWithNavBarTabItem(
      icon: Icon(
        Icons.shopping_bag,
      ),
      label: "Pedidos",
      initialLocation: "/a",
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
      // go to the initial location of the selected tab (by index)
      context.go(tabs[index].initialLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Container(
            margin: EdgeInsets.all(6),
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/kasane-teto.gif"),
            ),
          ),
          onTap: () {},
        ),
        title: const Center(
          child: Text("Meus Pedidos"),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          padding: const EdgeInsets.all(10),
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: widget.child,
        );
      }),
    );
  }
}
