import 'package:flutter/material.dart';

class Pedidos extends StatelessWidget {
  const Pedidos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CampoPedido(title: "Historico"),
          CampoPedido(title: "Em Andamento"),
        ],
      ),
    );
  }
}

class CampoPedido extends StatelessWidget {
  const CampoPedido({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Divider(),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pet Bacatinho"),
                  Divider(),
                  Text("N°: 1234"),
                  Text("Bacatinho bla bla bla"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: R\$ 100.00"),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Acompanhar",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
