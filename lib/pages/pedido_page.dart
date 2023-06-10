import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: InfiniteScrollListView(
        pagingController: controller,
        itemBuilder: (context, item, index) {
          return ServiceItem(item: item);
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        fetchData: fetchData,
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final PetShopServiceDto item;

  const ServiceItem({
    super.key,
    required this.item
  });

  @override
  Widget build(BuildContext context) {
    final onBackground = Theme.of(context).colorScheme.onBackground;
    var currecy =
        NumberFormat.simpleCurrency(decimalDigits: 2, locale: 'pt-BR');
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
                  image: NetworkImage(
                      'https://blog.cobasi.com.br/wp-content/uploads/2020/09/banho-tosa.png'),
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
                      isScrollControlled: true,
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NewOrderModal(
                            service: item,
                          ),
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
  }
}

class NewOrderModal extends StatefulWidget {
  final PetShopServiceDto service;

  NewOrderModal({super.key, required this.service});

  @override
  State<NewOrderModal> createState() => _NewOrderModalState();
}

class _NewOrderModalState extends State<NewOrderModal> {
  final _formKey = GlobalKey<FormBuilderState>();

  void addOrder() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ModalBottomSheetHeader(title: widget.service.name),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderField<Pet>(
                  name: 'pet',
                  builder: (field) {
                    return DropdownSearch<Pet>(
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
                        title: ModalBottomSheetHeader(title: "Pet"),
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
                      onChanged: (value) => field.didChange(value),
                      selectedItem: field.value,
                    );
                  },
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'notes',
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
                          "Total: R\$${widget.service.value}",
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
                        _formKey.currentState!.save();
                        var value = _formKey.currentState!.value;
                        final order = PetShopServiceOrderRequest(
                            value['pet'], widget.service, value['notes'], null);
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
