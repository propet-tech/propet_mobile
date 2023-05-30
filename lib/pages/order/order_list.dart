import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:propet_mobile/core/components/bottom_modal.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/models/breed/pet_breed.dart';
import 'package:propet_mobile/models/pet/pet.dart';
import 'package:propet_mobile/models/petshop_service.dart';
import 'package:propet_mobile/pages/pet/pet_card_item.dart';
import 'package:propet_mobile/services/pet_service.dart';
import 'package:propet_mobile/services/petshop_service.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Pedido"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
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
                    backgroundColor: Theme.of(context).colorScheme.background),
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
            DropdownSearch<PetShopServiceDto>(
              asyncItems: (_) => getIt<PetShopService>()
                  .getAllServices()
                  .then((value) => value.content),
              compareFn: (item1, item2) => item1.id == item2.id,
              popupProps: PopupProps.modalBottomSheet(
                listViewProps: ListViewProps(),
                modalBottomSheetProps: ModalBottomSheetProps(
                    useRootNavigator: true,
                    backgroundColor: Theme.of(context).colorScheme.background),
                title: ModalBottomSheetHeader(title: "Serviço"),
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    leading: Text("R\$ ${item.value}"),
                    subtitle: Text(item.description),
                    title: Text(item.name),
                  );
                },
                showSelectedItems: true,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Serviço",
                    icon: Icon(Icons.credit_card)),
              ),
              itemAsString: (item) => item.name,
              // onChanged: (value) => field.didChange(value),
              // selectedItem: field.value,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FormBuilderTextField(
                name: '',
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: const InputDecoration(
                    icon: Icon(Icons.notes),
                    border: OutlineInputBorder(),
                    labelText: "Notas"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  const ServiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: GridTile(
        header: GridTileBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text("Banho e tosa"),
        ),
        child: Image.asset(
          "assets/images/dog.jpg",
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          title: Text(
              "lksdjçflkjasçldfjçlaskdjfçlajsçdlfjaçlsdjfçlaksdjfçlajsdlfkjalkj"),
        ),
      ),
    );
  }
}
