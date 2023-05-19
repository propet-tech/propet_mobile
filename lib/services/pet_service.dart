import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/models/page/page.dart';
import 'package:propet_mobile/models/pet/pet.dart';
import 'package:propet_mobile/models/pet/pet_request.dart';

@Injectable()
class PetService {
  final Dio http;

  PetService(this.http);

  Future<PageContent<Pet>> getAllPets(
      {int? pageIndex, int? pageSize, String? sort}) {
    return http.get(
      "/pet",
      queryParameters: {"page": pageIndex, "size": pageSize, "sort": sort},
    ).then((value) {
      return PageContent.fromJson(value.data, (json) => Pet.fromJson(json!));
    });
  }

  Future<void> updatePet(PetRequest pet) async {
    await http.put("/pet", data: pet.toJson());
  }

  Future<void> addPetImage(int id, String filePath) async {
    var formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath, contentType: MediaType("image", "jpeg"))
    });

    await http.post("/pet/$id/image", data: formData);
  }
}
