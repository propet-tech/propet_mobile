import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/models/banner/banner.dart';

@Injectable()
class BannerService {
  final Dio http; 
  
  BannerService(this.http);

  Future<List<BannerDto>> listAllBanners() async {
    final response = await http.get("/banner");
    final List<dynamic> list = response.data;
    return list.map((e) => BannerDto.fromJson(e)).toList();
  }
}
