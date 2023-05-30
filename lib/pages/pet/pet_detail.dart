import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:go_router/go_router.dart';
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
  final Pet? pet;

  const PetDetailPage({super.key, this.pet});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormBuilderState>();
  final petService = getIt<PetService>();

  Future<bool> onSavePressed() async {
    _formKey.currentState!.save();
    final result = _formKey.currentState!.value;
    final request = PetRequest.fromJson(result);

    if (widget.pet == null) {
      await petService.createPet(request, image);
    } else {
      request.id = widget.pet!.id;
      await petService.updatePet(request, image);
    }
    return true;
  }

  String? image;

  Future<void> pickImage(ImageSource source) async {
    XFile? xfile = await picker.pickImage(source: source);
    if (xfile != null) {
      setState(() {
        image = xfile.path;
      });
    }
  }

  void onTapImage(BuildContext ctx) {
    ModalBottomSheet.show<ImageSource>(
      ctx,
      title: "Imagem do Pet",
      initialSelect: 0,
      actions: const [
        ModalBottomSheetAction(
          title: "Camera",
          value: ImageSource.camera,
        ),
        ModalBottomSheetAction(
          title: "Galeria",
          value: ImageSource.gallery,
        ),
        ModalBottomSheetAction(
          title: "Remover",
          value: null,
        )
      ],
      onChanged: (value) {
        if (value != null)
          pickImage(value);
        else
          setState(() => image = null);
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    if (image == null) {
      provider = widget.pet?.image != null
          ? DioImage(Uri.parse(widget.pet!.image!))
          : null;
    } else {
      provider = FileImage(File.fromUri(Uri.file(image!)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet?.name ?? "Novo Pet"),
        actions: [
          IconButton(
            onPressed: () {
              LoadingDialog.show(context, future: onSavePressed(),
                  onSuccess: () {
                context.pop();
                context.pop();
              });
              // context.pop();
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            "name": widget.pet?.name,
            "weight": widget.pet?.weight.toString(),
            "description": widget.pet?.description,
            "breedId": widget.pet?.breed
          },
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
              const SizedBox(height: 10),
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
                    child: BreedDropdown(name: "breedId"),
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
            ],
          ),
        ),
      ),
    );
  }
}

class BreedDropdown extends StatelessWidget with GetItMixin {
  final String name;

  BreedDropdown({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<PetBreed>(
      name: name,
      valueTransformer: (value) => value?.id,
      builder: (field) {
        return DropdownSearch<PetBreed>(
          asyncItems: (_) => get<BreedService>()
              .getAllBreeds()
              .then((value) => value!.content),
          compareFn: (item1, item2) => item1.id == item2.id,
          popupProps: PopupProps.modalBottomSheet(
            listViewProps: ListViewProps(),
            modalBottomSheetProps: ModalBottomSheetProps(
                useRootNavigator: true,
                backgroundColor: Theme.of(context).colorScheme.background),
            title: ModalBottomSheetHeader(title: "Raça"),
            showSelectedItems: true,
          ),
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Raça",
            ),
          ),
          onChanged: (value) => field.didChange(value),
          itemAsString: (breed) => breed.name,
          selectedItem: field.value,
        );
      },
    );
  }
}
