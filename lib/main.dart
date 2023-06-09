import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:propet_mobile/core/app_config_provider.dart';
import 'package:propet_mobile/core/components/dismiss_keyboard.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/providers/cart_provider.dart';
import 'package:propet_mobile/core/routes.dart';
import 'package:propet_mobile/core/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  Intl.defaultLocale = 'pt_BR';
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    configureDependencies(),
    getIt<AuthService>().autoLogin(),
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
        ChangeNotifierProvider.value(value: getIt<AuthService>()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => AppConfig())
      ],
      builder: (ctx, _) {
        return DismissKeyboard(
          child: MaterialApp.router(
            supportedLocales: const [
              Locale("pt", "BR"),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FormBuilderLocalizationsDelegate(),
            ],
            themeMode: ctx.watch<AppConfig>().mode,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
            darkTheme:
                ThemeData(useMaterial3: true, brightness: Brightness.dark),
            title: 'ProPet',
            routerDelegate: routes.routerDelegate,
            routeInformationParser: routes.routeInformationParser,
            routeInformationProvider: routes.routeInformationProvider,
          ),
        );
      },
    );
  }
}
