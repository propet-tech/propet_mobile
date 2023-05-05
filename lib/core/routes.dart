import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/entry_point.dart';
import 'package:propet_mobile/pages/home_page.dart';
import 'package:propet_mobile/pages/login_page.dart';
import 'package:propet_mobile/pages/order/track_pet.dart';
import 'package:propet_mobile/pages/pedido_page.dart';
import 'package:propet_mobile/pages/pet/pets_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routes = GoRouter(
  initialLocation: "/home",
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: "/login",
      builder: (context, state) {
        return LoginPage();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: "/orders",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: Pedidos());
          },
          routes: [
            GoRoute(
              path: ":id",
              builder: (context, state) {
                return PetTrack(id: int.parse(state.pathParameters['id']!));
              },
            )
          ],
        ),
        GoRoute(
          path: "/home",
          pageBuilder: (context, state) {
            return NoTransitionPage(child: HomePage());
          },
        ),
        GoRoute(
          path: "/pets",
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: PetsPage(),
            );
          },
        ),
      ],
    )
  ],
);
