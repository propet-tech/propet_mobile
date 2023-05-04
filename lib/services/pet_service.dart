import 'package:dio/dio.dart';
import 'package:propet_mobile/core/providers.dart';
import 'package:propet_mobile/models/page.dart';
import 'package:propet_mobile/models/pet.dart';

class PetService {
  final http = getIt<Dio>();

  Future<PageContent<Pet>> getAllPets([int? pageIndex, int? pageSize]) {
    return http.get(
      "http://192.168.1.124:8088/api/pet",
      queryParameters: {"page": pageIndex, "size": pageSize},
    ).then((value) {
      return PageContent.fromJson(value.data, (json) => Pet.fromJson(json));
    });
  }
}
