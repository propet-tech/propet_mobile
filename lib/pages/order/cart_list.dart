import 'package:flutter/material.dart';
import 'package:propet_mobile/core/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartList extends StatelessWidget {
  const CartList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus Pedidos")),
      body: ListView.builder(
        itemCount: context.read<CartProvider>().count,
        itemBuilder: (context, index) {
          return Text(context.read<CartProvider>().getOrder(index).notes!);
        },
      ),
    );
  }
}
