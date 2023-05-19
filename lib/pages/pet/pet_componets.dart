import 'package:flutter/material.dart';
import 'package:propet_mobile/core/dio_image_provider.dart';
import 'package:propet_mobile/models/pet/pet.dart';

class PetImage extends StatelessWidget {
  const PetImage({
    super.key,
    required this.pet,
  });

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      foregroundImage:
          pet.image != null ? DioImage(Uri.parse(pet.image!)) : null,
      child: const Icon(Icons.pets_sharp),
    );
  }
}
