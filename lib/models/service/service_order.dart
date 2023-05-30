import 'package:json_annotation/json_annotation.dart';

part 'service_order.g.dart';

@JsonSerializable()
class PetShopServiceOrderRequest {
  
  final int petId;
  final int serviceId;
  final String? notes;

  PetShopServiceOrderRequest(this.petId, this.serviceId, this.notes);

  factory PetShopServiceOrderRequest.fromJson(json) => _$PetShopServiceOrderRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PetShopServiceOrderRequestToJson(this);
}
