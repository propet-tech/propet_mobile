import 'package:json_annotation/json_annotation.dart';

part 'page.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PageContent<T> {
  List<T> content;
  bool last;

  PageContent({required this.content, required this.last});

  factory PageContent.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>? json) fromJsonT,
  ) =>
      _$PageContentFromJson(json, (Object? json) => fromJsonT(json as Map<String, dynamic>));
}
