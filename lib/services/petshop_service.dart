import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/models/page/page.dart';
import 'package:propet_mobile/models/petshop_service.dart';

@Injectable()
class PetShopService {
  final Dio http;

  PetShopService(this.http);
  
  Future<PageContent<PetShopServiceDto>> getAllServices() async {
    var response = await http.get("/service");
    return PageContent.fromJson(response.data, (json) => PetShopServiceDto.fromJson(json));
  }

  Future<List<PetShopServiceDto>> getTopService() async {
    var response = await http.get("/service/top");
    List<dynamic> list = response.data;
    return list.map((e) => PetShopServiceDto.fromJson(e['service'])).toList();
  }
}
