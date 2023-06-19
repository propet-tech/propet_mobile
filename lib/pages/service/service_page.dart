import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/components/bottom_modal.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/providers/cart_provider.dart';
import 'package:propet_mobile/models/pet/pet.dart';
import 'package:propet_mobile/models/petshop_service.dart';
import 'package:propet_mobile/models/service/service_order.dart';
import 'package:propet_mobile/pages/pet/pet_card_item.dart';
import 'package:propet_mobile/services/pet_service.dart';
import 'package:provider/provider.dart';

class ServicePage extends StatefulWidget {
  final PetShopServiceDto service;

  const ServicePage({super.key, required this.service});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            scrolledUnderElevation: 0,
            title: const Text("Novo Pedido"),
            centerTitle: true,
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            leading: const BackButton(
              color: Colors.white,
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                    Colors.black.withOpacity(0.9),
                    Colors.transparent
                  ])),
            )),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.asset(
                  "assets/images/banhoetosa.png",
                  fit: BoxFit.cover,
                  height: 230,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      widget.service.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.service.description,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
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
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Pet",
                                  prefixIcon: Icon(Icons.pets)),
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
                            prefixIcon: Icon(Icons.notes),
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              _formKey.currentState!.save();
                              var value = _formKey.currentState!.value;
                              final order = PetShopServiceOrderRequest(
                                  value['pet'],
                                  widget.service,
                                  value['notes'],
                                  null);
                              context.read<CartProvider>().add(order);
                              context.pop();
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
          ),
        ));
  }
}
