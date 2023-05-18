import 'package:json_annotation/json_annotation.dart';
part 'pet_breed.g.dart';

@JsonSerializable()
class PetBreed {
  int id;
  String name;

  PetBreed(this.id, this.name);

  factory PetBreed.fromJson(Map<String, dynamic> json) => _$PetBreedFromJson(json);

  Map<String, dynamic> toJson() => _$PetBreedToJson(this);
}
