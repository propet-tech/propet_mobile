import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/models/breed/pet_breed.dart';
import 'package:propet_mobile/models/page/page.dart';

@Injectable()
class BreedService {
  final Dio http;

  BreedService(this.http);

  Future<PageContent<PetBreed>?> getAllBreeds() async {
    var response = await http.get("/breed");
    return PageContent.fromJson(
        response.data, (json) => PetBreed.fromJson(json!));
  }
}
