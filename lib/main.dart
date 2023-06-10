import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propet_mobile/core/app_config_provider.dart';
import 'package:propet_mobile/core/app_state.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/providers/cart_provider.dart';
import 'package:propet_mobile/core/routes.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  Intl.defaultLocale = 'pt_BR';
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    configureDependencies(),
    getIt<AppState>().autoLogin(),
    initializeDateFormatting(),
  ]);

  runApp(const ProPetApp());
}

class ProPetApp extends StatelessWidget {
  const ProPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<AppState>()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => AppConfig())
      ],
      builder: (ctx, _) {
        return MaterialApp.router(
          themeMode: ctx.watch<AppConfig>().mode,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
          title: 'ProPet',
          routerDelegate: routes.routerDelegate,
          routeInformationParser: routes.routeInformationParser,
          routeInformationProvider: routes.routeInformationProvider,
        );
      },
    );
  }
}
