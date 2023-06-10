import 'package:json_annotation/json_annotation.dart';
import 'package:propet_mobile/models/pet/pet.dart';
import 'package:propet_mobile/models/petshop_service.dart';

part 'service_order.g.dart';

@JsonSerializable()
class PetShopServiceOrderRequest {
  
  final int? id;
  final Pet pet;
  final PetShopServiceDto service;
  final String? notes;

  PetShopServiceOrderRequest(this.pet, this.service, this.notes, this.id);

  factory PetShopServiceOrderRequest.fromJson(json) => _$PetShopServiceOrderRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PetShopServiceOrderRequestToJson(this);
}
