import 'package:flutter/material.dart';
import 'package:propet_mobile/models/service/order.dart';
import 'package:propet_mobile/models/service/service_order.dart';

class CartProvider extends ChangeNotifier {
  List<PetShopServiceOrderRequest> _orders = List.empty(growable: true);

  int get count => _orders.length;

  PetShopServiceOrderRequest getOrder(int index) => _orders[index];

  void removeAt(int index) {
    _orders.removeAt(index);
    notifyListeners();
  }

  double getTotalValue() =>
      _orders.fold(0, (value, element) => value + element.service.value);

  void add(PetShopServiceOrderRequest value) {
    _orders.add(value);
    notifyListeners();
  }

  void cleanCart() {
    _orders = List.empty(growable: true);
    notifyListeners();
  }

  List<PetShopOrder> getOrders() {
    return _orders
        .map((e) => PetShopOrder(
              e.pet.id,
              e.service.id,
              e.notes,
            ))
        .toList();
  }
}
