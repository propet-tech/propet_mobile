import 'package:flutter/material.dart';
import 'package:propet_mobile/core/providers.dart';
import 'package:propet_mobile/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String bacate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login biloso"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                getIt<AuthService>().authenticate().then((value) => bacate = value);
              });
            },
            child: Text("Login"),
          ),
          Text(bacate)
        ],
      ),
    );
  }
}
