import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propet_mobile/core/components/infinite_scroll_listview.dart';
import 'package:propet_mobile/core/components/loading_dialog.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/dio_image_provider.dart';
import 'package:propet_mobile/core/providers/cart_provider.dart';
import 'package:propet_mobile/models/service/service_order.dart';
import 'package:propet_mobile/pages/order/track_pet.dart';
import 'package:propet_mobile/pages/pet/pet_list_page.dart';
import 'package:propet_mobile/services/order_service.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Meu Carrinho"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pedido Atual'),
              Tab(text: 'Historico'),
            ],
          ),
        ),
        body: const TabBarView(children: [CartList(), OrderHistory()]),
      ),
    );
  }
}

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return InfiniteScrollListView<PetShopServiceOrderRequest>(
      itemBuilder: (context, item, index) {
        return CartItem(
            order: item,
            onClosePressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => PetTrack(id: item.id!),
              );
            });
      },
      separatorBuilder: (context, index) => SizedBox(height: 10),
      fetchData: (pageKey, pagingController) async {
        try {
          var result = await await getIt<OrderService>()
              .listOrders(pageIndex: pageKey, sort: null);
          if (result.last) {
            pagingController.appendLastPage(result.content);
          } else {
            pagingController.appendPage(result.content, pageKey++);
          }
        } catch (e) {
          pagingController.error = e;
        }
      },
    );
  }
}

class CartList extends StatelessWidget {
  const CartList({
    super.key,
  });

    void onFinishPressed(BuildContext context) async {
    var orderRequest = context.read<CartProvider>().getOrders();
    Future future = getIt<OrderService>().createOrders(orderRequest);
    context.read<CartProvider>().cleanCart();

    LoadingDialog.show(context, future: future);
  }

  @override
  Widget build(BuildContext context) {
    final currecy = NumberFormat.simpleCurrency();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Consumer<CartProvider>(
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: value.count,
                  itemBuilder: (context, index) {
                    return CartItem(
                      order: value.getOrder(index),
                      onClosePressed: () => value.removeAt(index),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const DividerWithoutMargin(),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total:",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Consumer<CartProvider>(
                    builder: (context, value, child) {
                      return Text(
                        currecy.format(value.getTotalValue()),
                        style: Theme.of(context).textTheme.titleLarge,
                      );
                    },
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => onFinishPressed(context.read<CartProvider>()),
                label: const Text("Finalizar"),
                icon: const Icon(Icons.arrow_forward),
              )
            ],
          ),
        )
      ],
    );
  }
}

class CartItem extends StatelessWidget {
  final PetShopServiceOrderRequest order;
  final void Function() onClosePressed;

  const CartItem(
      {super.key, required this.order, required this.onClosePressed});

  @override
  Widget build(BuildContext context) {
    final currecy = NumberFormat.simpleCurrency();
    final pet = order.pet;
    var image = pet.image != null ? DioImage(Uri.parse(pet.image!)) : null;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          foregroundImage: image,
          child: const Icon(Icons.pets_sharp),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(pet.name),
            Text(currecy.format(order.service.value)),
          ],
        ),
        subtitle: Text(order.service.name),
        trailing: IconButton(
          onPressed: onClosePressed,
          icon: const Icon(Icons.cancel),
        ),
      ),
    );
  }
}
