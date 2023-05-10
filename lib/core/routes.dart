import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/auth/auth_service.dart';
import 'package:propet_mobile/core/entry_point.dart';
import 'package:propet_mobile/pages/home_page.dart';
import 'package:propet_mobile/pages/loading_page.dart';
import 'package:propet_mobile/pages/login/login_page.dart';
import 'package:propet_mobile/pages/order/track_pet.dart';
import 'package:propet_mobile/pages/pedido_page.dart';
import 'package:propet_mobile/pages/pet/pets_page.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/services/user_service.dart';
import 'package:provider/provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routes = GoRouter(
  initialLocation: "/login",
  refreshListenable: getIt<AuthService>(),
  redirect: (context, state) {
    bool isAuthenticated = getIt<AuthService>().isAuthenticated();

    if (!isAuthenticated) return "/login";

    bool isLoginRoute = state.location == "/login";

    if (isLoginRoute) return "/home";

    return null;
  },
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: "/login",
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return FutureBuilder(
          future: getIt<UserService>().getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ChangeNotifierProvider.value(
                value: snapshot.data,
                child: ScaffoldNavBar(child: child),
              );
            } else {
              return const LoadingPage();
            }
          },
        );
      },
      routes: [
        GoRoute(
          path: "/orders",
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: Pedidos());
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
            return const NoTransitionPage(child: HomePage());
          },
        ),
        GoRoute(
          path: "/pets",
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: PetsPage(),
            );
          },
        ),
      ],
    )
  ],
);
