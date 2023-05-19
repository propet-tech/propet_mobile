import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propet_mobile/core/components/bottom_modal.dart';
import 'package:propet_mobile/core/components/loading_dialog.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/dio_image_provider.dart';
import 'package:propet_mobile/models/breed/pet_breed.dart';
import 'package:propet_mobile/models/pet/pet.dart';
import 'package:propet_mobile/models/pet/pet_request.dart';
import 'package:propet_mobile/services/breed_service.dart';
import 'package:propet_mobile/services/pet_service.dart';

class PetDetailPage extends StatefulWidget {
  final Object? state;

  const PetDetailPage({super.key, this.state});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormBuilderState>();

  Pet? pet;
  File? image;

  Future<void> pickImage(ImageSource source) async {
    XFile? xfile = await picker.pickImage(source: source);
    if (xfile != null) {
      setState(() {
        image = File(xfile.path);
      });
    }
  }

  final sortList = [
    Teste("Galeria", Icons.image, ImageSource.gallery),
    Teste("Camera", Icons.camera, ImageSource.camera),
    Teste("Remover", Icons.remove_circle, null),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.state != null) pet = widget.state as Pet;
  }

  void onTapImage(BuildContext context) {
    showMultiSelectBottomModal(
      context,
      MultiSelectBottomModalOptions(
        title: "Image do Pet",
        itemCount: sortList.length,
        initialSelect: 1,
        itemBuilder: (context, index, isSelected) {
          return ModalItem(
            isSelected: isSelected,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sortList[index].title),
                Icon(sortList[index].icon)
              ],
            ),
          );
        },
      ),
    ).then((value) {
      if (value != null) {
        var source = sortList[value].source;
        if (source != null) {
          pickImage(source);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    if (image != null) {
      provider = FileImage(image!);
    } else if (pet?.image != null) {
      provider = DioImage(Uri.parse(pet!.image!));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pet?.name ?? "Novo Pet"),
        actions: [
          IconButton(
              onPressed: () {
                _formKey.currentState!.save();
                var result = _formKey.currentState!.value;
                var pet = PetRequest.fromJson(result);
                pet.id = this.pet?.id;
                var future = Future.wait([
                  getIt<PetService>().updatePet(pet),
                  getIt<PetService>().addPetImage(pet.id!, image!.path)
                ]);
        LoadingDialog.show(context, future: future, title: Text("Pet Atualizado!"), content: Text("Pet Atualizado com sucesso!") );
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            "name": pet?.name ?? "",
            "weight": pet?.weight.toString(),
            "description": pet?.description ?? "",
            "breedId": pet?.breed
          },
          onChanged: () {},
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => onTapImage(context),
                child: CircleAvatar(
                  radius: 102,
                  backgroundColor: Theme.of(context).dividerColor,
                  child: CircleAvatar(
                    foregroundImage: provider,
                    radius: 100,
                    child: const Icon(Icons.pets_sharp),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: "name",
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    icon: Icon(Icons.pets),
                    border: OutlineInputBorder(),
                    labelText: "Nome"),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: FormBuilderTextField(
                      name: "weight",
                      valueTransformer: (value) => double.parse(value!),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: SizedBox(width: 24),
                        border: OutlineInputBorder(),
                        labelText: "Peso",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 3,
                    child: FormBuilderField<PetBreed>(
                      valueTransformer: (value) => value?.id,
                      name: "breedId",
                      builder: (FormFieldState<PetBreed> field) {
                        return DropdownSearch<PetBreed>(
                          asyncItems: (text) {
                            return getIt<BreedService>()
                                .getAllBreeds()
                                .then((value) => value!.content);
                          },
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Raça",
                            ),
                          ),
                          onChanged: (value) {
                            print(value);
                            field.didChange(value);
                          },
                          itemAsString: (breed) => breed.name,
                          selectedItem: field.value,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: "description",
                decoration: const InputDecoration(
                    icon: Icon(Icons.notes),
                    border: OutlineInputBorder(),
                    labelText: "Notas"),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              //   children: [
              // )
            ],
          ),
        ),
      ),
    );
  }
}

// Positioned(
//   child: Align(
//     alignment: Alignment.bottomCenter,
//     child: Container(
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.background
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedLoadButton(
//               icon: Icons.save,
//               label: "Salvar",
//               onPressed: () {
//                 _formKey.currentState!.save();
//                 // print(_formKey.currentState!.value.toString());
//                 var result = _formKey.currentState!.value;
//                 var pet = PetRequest.fromJson(result);
//                 pet.id = this.pet?.id!;
//                 return getIt<PetService>().updatePet(pet);
//               },
//             ),
//           ),
//           SizedBox(width: 10,),
//           Expanded(
//             child: ElevatedLoadButton(
//               icon: Icons.save,
//               label: "Cancelar",
//               onPressed: () {
//                 _formKey.currentState!.save();
//                 // print(_formKey.currentState!.value.toString());
//                 var result = _formKey.currentState!.value;
//                 var pet = PetRequest.fromJson(result);
//                 pet.id = this.pet?.id!;
//                 return getIt<PetService>().updatePet(pet);
//               },
//             ),
//           ),
//         ],
//       ),
//     ),
//   ), //   ],
// )

class Teste {
  String title;
  IconData icon;
  ImageSource? source;

  Teste(this.title, this.icon, this.source);
}
