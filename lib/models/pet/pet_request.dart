import 'package:json_annotation/json_annotation.dart';
part 'pet_request.g.dart';

@JsonSerializable()
class PetRequest {
  int? id;
  String name;
  int breedId;
  double? weight;
  String? description;

  PetRequest(this.id, this.name, this.breedId, this.weight, this.description);

  factory PetRequest.fromJson(Map<String, dynamic> json) => _$PetRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PetRequestToJson(this);
}
