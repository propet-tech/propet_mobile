import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/services/auth_service.dart';
import 'package:propet_mobile/models/pet/pet.dart';
import 'package:propet_mobile/models/petshop_service.dart';
import 'package:propet_mobile/pages/config/config_page.dart';
import 'package:propet_mobile/pages/entry/entry_point.dart';
import 'package:propet_mobile/pages/home/home_page.dart';
import 'package:propet_mobile/pages/login/login_page.dart';
import 'package:propet_mobile/pages/order/cart_list.dart';
import 'package:propet_mobile/pages/order/track_pet.dart';
import 'package:propet_mobile/pages/pet/pet_detail.dart';
import 'package:propet_mobile/pages/pet/pet_list_page.dart';
import 'package:propet_mobile/pages/service/pedido_page.dart';
import 'package:propet_mobile/pages/service/service_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routes = GoRouter(
  initialLocation: "/login",
  navigatorKey: _rootNavigatorKey,
  refreshListenable: getIt<AuthService>(),
  redirect: (context, state) {
    bool isAuthenticated = getIt<AuthService>().isAuthenticated();

    if (!isAuthenticated) return "/login";

    bool isLoginRoute = state.location == "/login";

    if (isLoginRoute) return "/home";

    return null;
  },
  routes: [
    GoRoute(
      path: "/login",
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: "/config",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ConfigPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/home",
            builder: (context, state) {
              return HomePage();
            },
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/pets",
              builder: (context, state) {
                return PetListPage();
              },
              routes: [
                GoRoute(
                  path: "edit",
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final pet = state.extra as Pet?;
                    return PetDetailPage(pet: pet);
                  },
                ),
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/orders",
            builder: (context, state) {
              return Pedidos();
            },
            routes: [
              GoRoute(
                path: "track/:id",
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  return PetTrack(id: int.parse(state.pathParameters['id']!));
                },
              ),
              GoRoute(
                path: "cart",
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  return CartPage();
                },
              ),
              GoRoute(
                path: "new",
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final service = state.extra as PetShopServiceDto;
                  return ServicePage(service: service,);
                },
              )
            ],
          ),
        ]),
      ],
    )
  ],
);
