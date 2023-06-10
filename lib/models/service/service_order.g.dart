// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetShopServiceOrderRequest _$PetShopServiceOrderRequestFromJson(
        Map<String, dynamic> json) =>
    PetShopServiceOrderRequest(
      Pet.fromJson(json['pet'] as Map<String, dynamic>),
      PetShopServiceDto.fromJson(json['service']),
      json['notes'] as String?,
      json['id'] as int?,
    );

Map<String, dynamic> _$PetShopServiceOrderRequestToJson(
        PetShopServiceOrderRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet': instance.pet,
      'service': instance.service,
      'notes': instance.notes,
    };
