import 'package:json_annotation/json_annotation.dart';
import 'package:propet_mobile/models/breed/pet_breed.dart';
part 'pet.g.dart';

@JsonSerializable()
class Pet {
  int id;
  String name;
  String user;
  PetBreed breed;
  double weight;
  String? image;
  String? description;

  Pet(
    this.id,
    this.name,
    this.image,
    this.user,
    this.breed,
    this.weight,
    this.description,
  );

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
  Map<String, dynamic> toJson() => _$PetToJson(this);
}
