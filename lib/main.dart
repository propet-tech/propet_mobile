import 'package:flutter/material.dart';
import 'package:propet_mobile/core/providers.dart';
import 'package:propet_mobile/core/routes.dart';

void main() {
  setupProviders();
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

