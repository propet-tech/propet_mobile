// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetShopOrder _$PetShopOrderFromJson(Map<String, dynamic> json) => PetShopOrder(
      json['petId'] as int,
      json['serviceId'] as int,
      json['notes'] as String?,
    );

Map<String, dynamic> _$PetShopOrderToJson(PetShopOrder instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'serviceId': instance.serviceId,
      'notes': instance.notes,
    };
