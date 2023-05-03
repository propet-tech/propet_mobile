import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/pages/home_page.dart';
import 'package:propet_mobile/pages/pedido_page.dart';

void main() {
  runApp(const MyApp());
}

final routes = GoRouter(
  initialLocation: "/a",
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: "/a",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: Pedidos());
          },
        ),
        GoRoute(
          path: "/b",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: HomePage());
          },
        )
      ],
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ProPet',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routerDelegate: routes.routerDelegate,
      routeInformationParser: routes.routeInformationParser,
      routeInformationProvider: routes.routeInformationProvider,
    );
  }
}

class ScaffoldWithNavBarTabItem extends BottomNavigationBarItem {
  const ScaffoldWithNavBarTabItem(
      {required this.initialLocation, required Widget icon, String? label})
      : super(icon: icon, label: label);

  /// The initial location/path
  final String initialLocation;
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
        icon: Icon(Icons.home), label: "Home", initialLocation: "/a"),
    const ScaffoldWithNavBarTabItem(
        icon: Icon(Icons.pets), label: "Pets", initialLocation: "/b"),
    const ScaffoldWithNavBarTabItem(
        icon: Icon(Icons.shopping_bag),
        label: "Pedidos",
        initialLocation: "/a"),
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
