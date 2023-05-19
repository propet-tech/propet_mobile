import 'package:flutter/material.dart';
import 'package:propet_mobile/core/app_config_provider.dart';
import 'package:propet_mobile/core/app_state.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    configureDependencies(),
  ]);

  runApp(const ProPetApp());
}

class ProPetApp extends StatelessWidget {
  const ProPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AppConfig(),
      builder: (context, _) {
        return MaterialApp.router(
          themeMode: context.watch<AppConfig>().mode,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
          title: 'ProPet',
          routerDelegate: routes.routerDelegate,
          routeInformationParser: routes.routeInformationParser,
          routeInformationProvider: routes.routeInformationProvider,
          builder: (context, child) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: getIt<AppState>())
              ],
              child: child,
            );
          },
        );
      },
    );
  }
}
