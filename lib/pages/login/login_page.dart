import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propet_mobile/core/auth/auth_service.dart';
import 'package:propet_mobile/core/dependencies.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  final auth = getIt<AuthService>();

  void submit() {
    setState(() {
      loading = true;
    });

    auth.login().catchError((e) {
      var error = e as PlatformException;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.message ?? "Um error inesperado aconteceu!")),
      );
    }).whenComplete(() => setState(() => loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade200,
                Colors.blue.shade500,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(
                      height: 250,
                      image: AssetImage("assets/images/logo-light.png"),
                    ),
                  ],
                ),
              ),
              Align(
                child: ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Login"),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
