// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderHistoryResponse _$OrderHistoryResponseFromJson(
        Map<String, dynamic> json) =>
    OrderHistoryResponse(
      json['id'] as int,
      DateTime.parse(json['dateTime'] as String),
      json['status'] as String,
      json['petshopOrderId'] as int,
    );

Map<String, dynamic> _$OrderHistoryResponseToJson(
        OrderHistoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateTime': instance.dateTime.toIso8601String(),
      'status': instance.status,
      'petshopOrderId': instance.petshopOrderId,
    };
