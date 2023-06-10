import 'package:json_annotation/json_annotation.dart';

part 'order_history_response.g.dart';

@JsonSerializable()
class OrderHistoryResponse {
  int id;
  DateTime dateTime;
  String status;
  int petshopOrderId;

  OrderHistoryResponse(
    this.id,
    this.dateTime,
    this.status,
    this.petshopOrderId,
  );

  factory OrderHistoryResponse.fromJson(json) => _$OrderHistoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrderHistoryResponseToJson(this);

}
