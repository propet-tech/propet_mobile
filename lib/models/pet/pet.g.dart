// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pet _$PetFromJson(Map<String, dynamic> json) => Pet(
      json['id'] as int,
      json['name'] as String,
      json['image'] as String?,
      json['userId'] as int,
      PetBreed.fromJson(json['breed'] as Map<String, dynamic>),
      (json['weight'] as num).toDouble(),
      json['description'] as String?,
    );

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userId': instance.userId,
      'breed': instance.breed,
      'weight': instance.weight,
      'image': instance.image,
      'description': instance.description,
    };
