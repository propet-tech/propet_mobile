
import 'package:json_annotation/json_annotation.dart';

part 'petshop_service.g.dart';

@JsonSerializable()
class PetShopService {
  final String status;   

  PetShopService({required this.status});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PetShopService.fromJson(json) => _$PetShopServiceFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PetShopServiceToJson(this);
}
