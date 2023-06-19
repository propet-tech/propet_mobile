import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/app_state.dart';
import 'package:propet_mobile/core/components/profile_picture.dart';
import 'package:propet_mobile/core/providers/cart_provider.dart';
import 'package:propet_mobile/core/services/auth_service.dart';
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

class ScaffoldNavBar extends StatelessWidget {

  final StatefulNavigationShell navigationShell;

  const ScaffoldNavBar({super.key, required this.navigationShell});

  final tabs = const [
    ScaffoldWithNavBarTabItem(
      icon: Icon(Icons.home),
      label: "Home",
      title: "Home",
      initialLocation: "/home",
    ),
    ScaffoldWithNavBarTabItem(
      icon: Icon(Icons.pets),
      title: "Meus Pets",
      label: "Pets",
      initialLocation: "/pets",
    ),
    ScaffoldWithNavBarTabItem(
      icon: Icon(Icons.shopping_bag),
      title: "Serviços",
      label: "Serviços",
      initialLocation: "/orders",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userinfo = context.read<AuthService>().userinfo;
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
        title: Text(tabs[navigationShell.currentIndex].title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        items: tabs,
        onTap: (value) {
          navigationShell.goBranch(value);
        },
      ),
      body: navigationShell,
    );
  }
}
