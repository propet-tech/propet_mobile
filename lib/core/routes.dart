import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/entry_point.dart';
import 'package:propet_mobile/pages/home_page.dart';
import 'package:propet_mobile/pages/pedido_page.dart';

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
