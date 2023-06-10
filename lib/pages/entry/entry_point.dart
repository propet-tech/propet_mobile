import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/app_state.dart';
import 'package:propet_mobile/core/components/profile_picture.dart';
import 'package:propet_mobile/core/providers/cart_provider.dart';
import 'package:propet_mobile/pages/entry/drawer.dart';
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
      icon: Icon(Icons.home),
      label: "Home",
      title: "Home",
      initialLocation: "/home",
    ),
    const ScaffoldWithNavBarTabItem(
      icon: Icon(Icons.pets),
      title: "Meus Pets",
      label: "Pets",
      initialLocation: "/pets",
    ),
    const ScaffoldWithNavBarTabItem(
      icon: Icon(Icons.shopping_bag),
      title: "Serviços",
      label: "Serviços",
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
    final userinfo = context.read<AppState>().userinfo;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      drawer: const AppDrawer(),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 18),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => context.push("/orders/cart"),
              child: Badge(
                label: Consumer<CartProvider>(
                  builder: (context, value, child) =>
                      Text(value.count.toString()),
                ),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              child: Container(
                margin: const EdgeInsets.all(6),
                child: ProfilePicture(
                  userInfo: userinfo!,
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
        items: tabs,
        onTap: (value) {
          onTap(value);
        },
      ),
      body: widget.child,
    );
  }
}
