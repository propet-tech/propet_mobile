import 'package:json_annotation/json_annotation.dart';

part 'page.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PageContent<T> {
  List<T> content;
  bool last;

  PageContent({required this.content, required this.last});

  factory PageContent.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PageContentFromJson(json, fromJsonT);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  // Map<String, dynamic> toJson() => _$PageToJson(this, toJsonT);
}
