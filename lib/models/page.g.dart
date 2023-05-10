// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageContent<T> _$PageContentFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PageContent<T>(
      content: (json['content'] as List<dynamic>).map(fromJsonT).toList(),
      last: json['last'] as bool,
    );

Map<String, dynamic> _$PageContentToJson<T>(
  PageContent<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'content': instance.content.map(toJsonT).toList(),
      'last': instance.last,
    };
