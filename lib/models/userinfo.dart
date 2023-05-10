import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'userinfo.g.dart';

@JsonSerializable()
class UserInfo with ChangeNotifier {
  String? picture; 
  String? name;

  UserInfo({required this.picture, required this.name});

  factory UserInfo.fromJson(json) => _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
