import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/dio_image_provider.dart';
import 'package:propet_mobile/models/pet/pet.dart';

class PetCardItem extends StatelessWidget {
  final Pet pet;

  const PetCardItem({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    var image = pet.image != null ? DioImage(Uri.parse(pet.image!)) : null;
    return GestureDetector(
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            foregroundImage: image,
            child: const Icon(Icons.pets_sharp),
          ),
          title: Text(pet.name),
          subtitle: Text("${pet.weight.toString()} Kg"),
          trailing: const Icon(Icons.more_vert),
        ),
      ),
      onTap: () {
        context.push("/pets/edit", extra: pet);
      },
    );
  }
}
