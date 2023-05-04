import 'package:json_annotation/json_annotation.dart';
part 'pet.g.dart';

@JsonSerializable()
class Pet {
  int id;
  String name;
  // UUID? userId;
  // PetBreed? breed;
  // PetCategory: category;
  double? weight;
  String? description;

  Pet({
    required this.id,
    required this.name,
    // this.userId,
    // this.breed,
    // this.category,
    this.weight,
    this.description,
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Pet.fromJson(json) => _$PetFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PetToJson(this);
}
