import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:propet_mobile/core/components/divider.dart';
import 'package:propet_mobile/core/components/infinite_scroll_listview.dart';
import 'package:propet_mobile/core/components/loading_dialog.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/dio_image_provider.dart';
import 'package:propet_mobile/core/paging_controller.dart';
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

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final pagingController =
      CustomPagingController<PetShopServiceOrderRequest>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener(
      (pageKey) async {
        try {
          var result = await getIt<OrderService>()
              .listOrders(pageIndex: pageKey, sort: null);
          if (result.last) {
            pagingController.appendLastPage(result.content);
          } else {
            pagingController.appendPage(result.content, ++pageKey);
          }
        } catch (e) {
          pagingController.error = e;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InfiniteScrollListView<PetShopServiceOrderRequest>(
        pagingController: pagingController,
        itemBuilder: (context, item, index) {
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              child: CartListTile(order: item),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => PetTrack(id: item.id!),
                );
              },
            ),
          );
        },
      ),
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

    LoadingDialog.show(context, future: future.then((value) => true));
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
                    return Card(
                      child: CartListTile(
                        order: value.getOrder(index),
                        onClosePressed: () => value.removeAt(index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const DividerWithoutMargin(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleMedium!,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Sub Total:",
                          ),
                          Consumer<CartProvider>(
                            builder: (context, value, child) {
                              return Text(
                                currecy.format(value.getTotalValue()),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Entrega:",
                          ),
                          Text(
                            currecy.format(10),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                          ),
                          Consumer<CartProvider>(
                            builder: (context, value, child) {
                              return Text(
                                currecy.format(value.getTotalValue() + 10),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => onFinishPressed(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.background),
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

class CartListTile extends StatelessWidget {
  const CartListTile({super.key, required this.order, this.onClosePressed});

  final PetShopServiceOrderRequest order;
  final void Function()? onClosePressed;

  @override
  Widget build(BuildContext context) {
    final currecy = NumberFormat.simpleCurrency();
    final image =
        order.pet.image != null ? DioImage(Uri.parse(order.pet.image!)) : null;
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: image,
        child: const Icon(Icons.pets_sharp),
      ),
      title: Text(order.pet.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(order.service.name),
          Text("Total: ${currecy.format(order.service.value)}"),
        ],
      ),
      trailing: onClosePressed == null
          ? null
          : IconButton(
              onPressed: onClosePressed,
              icon: const Icon(Icons.cancel),
            ),
    );
  }
}
