import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/models/page/page.dart';
import 'package:propet_mobile/models/service/order.dart';
import 'package:propet_mobile/models/service/service_order.dart';

@Injectable()
class OrderService {
  final Dio http; 

  const OrderService(this.http);

  Future<void> createOrders(List<PetShopOrder> orders) async {
    final data = jsonEncode(orders.map((e) => e.toJson()).toList());
    await http.post("/order", data: data);
  }

  Future<PageContent<PetShopServiceOrderRequest>> listOrders({int? pageIndex, int? pageSize, String? sort}) async {
    final response = await http.get("/order", queryParameters: {
      "page": pageIndex,
      "size": pageSize,
      "sort": sort,
    });
    return PageContent.fromJson(response.data, (json) => PetShopServiceOrderRequest.fromJson(json));
  }
  
}
