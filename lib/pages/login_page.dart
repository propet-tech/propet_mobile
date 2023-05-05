import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Bem vindo ao Propet!",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 25),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      hintText: "E-mail",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      fillColor: Colors.grey,
                      filled: true),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      hintText: "Senha",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      )),
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: () {
                  context.go("/home");
                }, child: Text("Login"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
