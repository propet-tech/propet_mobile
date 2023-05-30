import 'dart:convert';
import 'dart:io';

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
      {int? pageIndex, int? pageSize, String? sort}) async {
    var reponse = await http.get("/pet", queryParameters: {
      "page": pageIndex,
      "size": pageSize,
      "sort": sort,
    });

    return PageContent.fromJson(reponse.data, (json) => Pet.fromJson(json!));
  }

  Future<void> createPet(PetRequest pet, [String? imagePath]) async {
    Map<String, dynamic> form = {
      "pet": MultipartFile.fromString(
        jsonEncode(pet.toJson()),
        contentType: MediaType.parse("application/json"),
      ),
    };

    if (imagePath != null) {
      final imagemf = await MultipartFile.fromFile(
        imagePath,
        contentType: MediaType("image", "jpeg"),
      );
      form.addEntries([MapEntry("image", imagemf)]);
    }

    var formData = FormData.fromMap(form);
    await http.post("/pet", data: formData);
  }

  Future<void> updatePet(PetRequest pet, [String? imagePath]) async {
    Map<String, dynamic> form = {
      "pet": MultipartFile.fromString(
        jsonEncode(pet.toJson()),
        contentType: MediaType.parse("application/json"),
      ),
    };

    if (imagePath != null) {
      final imagemf = await MultipartFile.fromFile(
        imagePath,
        contentType: MediaType("image", "jpeg"),
      );
      form.addEntries([MapEntry("image", imagemf)]);
    }

    var formData = FormData.fromMap(form);
    await http.put("/pet", data: formData);
  }

  Future<void> removePet(int id) async {
    await http.delete("/pet/$id");
  }
}
