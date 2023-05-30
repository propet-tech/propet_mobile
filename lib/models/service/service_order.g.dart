// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetShopServiceOrderRequest _$PetShopServiceOrderRequestFromJson(
        Map<String, dynamic> json) =>
    PetShopServiceOrderRequest(
      json['petId'] as int,
      json['serviceId'] as int,
      json['notes'] as String?,
    );

Map<String, dynamic> _$PetShopServiceOrderRequestToJson(
        PetShopServiceOrderRequest instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'serviceId': instance.serviceId,
      'notes': instance.notes,
    };
