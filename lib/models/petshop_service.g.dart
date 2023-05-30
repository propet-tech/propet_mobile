// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'petshop_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetShopServiceDto _$PetShopServiceDtoFromJson(Map<String, dynamic> json) =>
    PetShopServiceDto(
      id: json['id'] as int,
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$PetShopServiceDtoToJson(PetShopServiceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
      'description': instance.description,
    };
