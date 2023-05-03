import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/entry_point.dart';
import 'package:propet_mobile/pages/home_page.dart';
import 'package:propet_mobile/pages/login_page.dart';
import 'package:propet_mobile/pages/pedido_page.dart';

final routes = GoRouter(
  initialLocation: "/home",
  routes: [
    GoRoute(
      path: "/login",
      builder: (context, state) {
        return LoginPage();
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: "/orders",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: Pedidos());
          },
        ),
        GoRoute(
          path: "/home",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: HomePage());
          },
        )
      ],
    )
  ],
);
