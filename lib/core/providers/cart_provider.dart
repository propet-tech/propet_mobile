import 'package:flutter/material.dart';
import 'package:propet_mobile/models/service/service_order.dart';

class CartProvider extends ChangeNotifier {
  final List<PetShopServiceOrderRequest> _orders = List.empty(growable: true); 

  int get count => _orders.length;

  PetShopServiceOrderRequest getOrder(int index) => _orders[index];

  void add(PetShopServiceOrderRequest value) {
    _orders.add(value);
    notifyListeners();
  }
}
