import 'package:flutter/material.dart';
import 'package:propet_mobile/core/auth/auth_service.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/models/userinfo.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String getGreeting() {
    var hours = DateTime.now().hour;

    if (hours >= 6 && hours <= 12) {
      return "Bom dia";
    } else if (hours > 12 && hours < 18) {
      return "Boa Tarde";
    } else if (hours >= 18 && hours <= 23) {
      return "Boa Noite";
    } else {
      return "Boa Madrugada";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${getGreeting()}, ${context.read<UserInfo>().name}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
