import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class PetShopOrder {
  
  final int petId;
  final int serviceId;
  final String? notes;

  PetShopOrder(this.petId, this.serviceId, this.notes);

  factory PetShopOrder.fromJson(json) => _$PetShopOrderFromJson(json);
  Map<String, dynamic> toJson() => _$PetShopOrderToJson(this);
}
