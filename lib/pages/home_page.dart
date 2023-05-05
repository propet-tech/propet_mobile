import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(onPressed: () {
        context.go("/login");
      }, child: Text("Login")),
    );
  }
}
