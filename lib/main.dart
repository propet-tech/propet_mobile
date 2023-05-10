import 'package:flutter/material.dart';
import 'package:propet_mobile/core/routes.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/pages/loading_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: LoadingPage(),
  ));
  // init dependencies
  await Future.delayed(Duration(seconds: 10));
  await configureDependencies();
  runApp(const ProPetApp());
}

class ProPetApp extends StatelessWidget {
  const ProPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ProPet',
      routerDelegate: routes.routerDelegate,
      routeInformationParser: routes.routeInformationParser,
      routeInformationProvider: routes.routeInformationProvider,
    );
  }
}
