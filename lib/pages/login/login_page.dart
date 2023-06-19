import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  void submit() async {
    try {
      setState(() => loading = true);
      await getIt<AuthService>().login();
    } on PlatformException catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ex.message ?? "Um error inesperado aconteceu!"),
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Image(
                    height: 180,
                    image: AssetImage("assets/images/logo-light.png"),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.background,
              ),
              child: loading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.background,
                    )
                  : const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
