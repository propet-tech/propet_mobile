import 'package:json_annotation/json_annotation.dart';

part 'petshop_service.g.dart';

@JsonSerializable()
class PetShopServiceDto {
  final int id;
  final String name;
  final double value;
  final String description;
  // final String status = true;

  PetShopServiceDto({
    required this.id,
    required this.name,
    required this.value,
    required this.description,
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PetShopServiceDto.fromJson(json) => _$PetShopServiceDtoFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PetShopServiceDtoToJson(this);
}
