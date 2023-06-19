import 'package:json_annotation/json_annotation.dart';

part 'banner.g.dart';

@JsonSerializable()
class BannerDto {
  final int id;
  final String image;

  BannerDto(this.id, this.image);

  factory BannerDto.fromJson(Map<String, dynamic> json) => _$BannerDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BannerDtoToJson(this);
}
