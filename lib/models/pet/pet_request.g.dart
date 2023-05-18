// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetRequest _$PetRequestFromJson(Map<String, dynamic> json) => PetRequest(
      json['id'] as int?,
      json['name'] as String,
      json['breedId'] as int,
      (json['weight'] as num?)?.toDouble(),
      json['description'] as String?,
    );

Map<String, dynamic> _$PetRequestToJson(PetRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'breedId': instance.breedId,
      'weight': instance.weight,
      'description': instance.description,
    };
