import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:propet_mobile/core/components/bottom_modal.dart';
import 'package:propet_mobile/core/components/infinite_scroll_listview.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/paging_controller.dart';
import 'package:propet_mobile/core/providers/cart_provider.dart';
import 'package:propet_mobile/models/pet/pet.dart';
import 'package:propet_mobile/models/petshop_service.dart';
import 'package:propet_mobile/models/service/service_order.dart';
import 'package:propet_mobile/pages/pet/pet_card_item.dart';
import 'package:propet_mobile/services/pet_service.dart';
import 'package:propet_mobile/services/petshop_service.dart';
import 'package:provider/provider.dart';

class Pedidos extends StatefulWidget {
  Pedidos({super.key});

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  late final CustomPagingController<int, PetShopServiceDto> controller =
      CustomPagingController(firstPageKey: 0);

  void fetchData(int pageKey, _) async {
    try {
      var result = await getIt<PetShopService>().getAllServices();
      if (result.last) {
        controller.appendLastPage(result.content);
      } else {
        controller.appendPage(result.content, pageKey++);
      }
    } catch (e) {
      controller.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    var currecy =
        NumberFormat.simpleCurrency(decimalDigits: 2, locale: 'pt-BR');
    final onBackground = Theme.of(context).colorScheme.onBackground;

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: InfiniteScrollListView(
        pagingController: controller,
        itemBuilder: (context, item, index) {
          return Card(
            child: Container(
              child: Column(
                children: [
                  GridTileBar(
                    leading: Icon(
                      Icons.spa,
                      color: onBackground,
                    ),
                    title: Text(
                      item.name,
                      style: TextStyle(color: onBackground),
                    ),
                    trailing: Text(currecy.format(item.value)),
                    // backgroundColor: Theme.of(context)
                    //     .colorScheme
                    //     .background
                    //     .withOpacity(0.80),
                  ),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://blog.cobasi.com.br/wp-content/uploads/2020/09/banho-tosa.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  //     footer: Material(
                  //       color: Theme.of(context)
                  //           .colorScheme
                  //           .background
                  //           .withOpacity(0.80),
                  GridTileBar(
                    // backgroundColor: Theme.of(context)
                    //     .colorScheme
                    //     .background
                    //     .withOpacity(0.80),
                    subtitle: Text(
                      item.description,
                      style: TextStyle(color: onBackground),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            useRootNavigator: true,
                            builder: (_) {
                              return NewOrderModal(
                                service: item,
                              );
                            },
                          );
                          // context.read<CartProvider>().add(1);
                        },
                        icon: Icon(
                          Icons.add_card,
                          color: onBackground,
                        )),
                  ),
                  //     ),
                  //   ),
                ],
              ),
            ),
            // borderRadius: BorderRadius.circular(10),
            // child: SizedBox(
            //   height: 230,
            //   child: GridTile(
            //     child: Container(
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //           fit: BoxFit.cover,
            //           image: NetworkImage(
            //             "https://blog.cobasi.com.br/wp-content/uploads/2020/09/banho-tosa.png",
            //           ),
            //         ),
            //       ),
            //     ),
            //     header: GridTileBar(
            //       leading: Icon(
            //         Icons.spa,
            //         color: onBackground,
            //       ),
            //       title: Text(
            //         item.name,
            //         style: TextStyle(color: onBackground),
            //       ),
            //       trailing: Text(currecy.format(item.value)),
            //       backgroundColor: Theme.of(context)
            //           .colorScheme
            //           .background
            //           .withOpacity(0.80),
            //     ),
            //     footer: Material(
            //       color: Theme.of(context)
            //           .colorScheme
            //           .background
            //           .withOpacity(0.80),
            //       child: GridTileBar(
            //         subtitle: Text(
            //           item.description,
            //           style: TextStyle(color: onBackground),
            //         ),
            //         trailing: IconButton(
            //             onPressed: () {
            //               showModalBottomSheet(
            //                 context: context,
            //                 useRootNavigator: true,
            //                 builder: (_) {
            //                   return NewOrderModal(
            //                     service: item,
            //                   );
            //                 },
            //               );
            //               // context.read<CartProvider>().add(1);
            //             },
            //             icon: Icon(
            //               Icons.add_card,
            //               color: onBackground,
            //             )),
            //       ),
            //     ),
            //   ),
            // ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
        fetchData: fetchData,
      ),
    );
    //   return Container(
    //     padding: EdgeInsets.all(10),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         CampoPedido(title: "Historico"),
    //         CampoPedido(title: "Em Andamento"),
    //       ],
    //     ),
    //   );
  }
}

class NewOrderModal extends StatelessWidget {
  final PetShopServiceDto service;
  final _formKey = GlobalKey<FormBuilderState>();

  NewOrderModal({super.key, required this.service});

  void addOrder() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ModalBottomSheetHeader(title: service.name),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: FormBuilder(
            child: Column(
              children: [
                DropdownSearch<Pet>(
                  asyncItems: (_) => getIt<PetService>()
                      .getAllPets()
                      .then((value) => value.content),
                  compareFn: (item1, item2) => item1.id == item2.id,
                  popupProps: PopupProps.modalBottomSheet(
                    listViewProps: ListViewProps(),
                    modalBottomSheetProps: ModalBottomSheetProps(
                        useRootNavigator: true,
                        backgroundColor:
                            Theme.of(context).colorScheme.background),
                    title: ModalBottomSheetHeader(title: "Serviço"),
                    itemBuilder: (context, item, isSelected) {
                      return PetCardItem(pet: item);
                    },
                    showSelectedItems: true,
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Pet",
                        icon: Icon(Icons.pets)),
                  ),
                  itemAsString: (item) => item.name,
                  // onChanged: (value) => field.didChange(value),
                  // selectedItem: field.value,
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: '',
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.notes),
                      border: OutlineInputBorder(),
                      labelText: "Notas"),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info),
                        const SizedBox(width: 10),
                        Text(
                          "Total: R\$${service.value}",
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        final order = PetShopServiceOrderRequest(1, 2, "aaa");
                        context.read<CartProvider>().add(order);
                      },
                      label: Text("Adicionar"),
                      icon: Icon(Icons.done),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
