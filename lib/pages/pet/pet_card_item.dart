import 'package:flutter/material.dart';
import 'package:propet_mobile/models/pet.dart';

class PetCardItem extends StatelessWidget {
  final Pet pet;

  const PetCardItem({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage("assets/images/dog.jpg"),
        ),
        title: Text(pet.name),
        subtitle: Text("${pet.weight.toString()} Kg"),
        // isThreeLine: true,
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
