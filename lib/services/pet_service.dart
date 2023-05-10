import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/models/page.dart';
import 'package:propet_mobile/models/pet.dart';

@Injectable()
class PetService {
  final Dio http;

  PetService(this.http);

  Future<PageContent<Pet>> getAllPets([int? pageIndex, int? pageSize]) {
    return http.get(
      "/pet",
      queryParameters: {"page": pageIndex, "size": pageSize},
    ).then((value) {
      return PageContent.fromJson(value.data, (json) => Pet.fromJson(json));
    });
  }
}
