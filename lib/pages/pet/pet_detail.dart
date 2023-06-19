import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
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
      await petService.createPet(request, image.value);
    } else {
      request.id = widget.pet!.id;
      await petService.updatePet(request, image.value);
    }
    return true;
  }

  final image = ValueNotifier<File?>(null);

  Future<void> pickImage(ImageSource source) async {
    XFile? xfile = await picker.pickImage(source: source);

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: xfile!.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            backgroundColor: Theme.of(context).colorScheme.background,
            toolbarColor: Theme.of(context).colorScheme.background,
            statusBarColor: Theme.of(context).colorScheme.background ,
            
            toolbarTitle: 'Cropper',
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            hideBottomControls: true,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      image.value = File(croppedFile.path);
    }
  }

  void _onTapImage(BuildContext ctx) {
    ModalBottomSheet.show(
      ctx,
      title: "Imagem do Pet",
      initialSelect: 1,
      actions: [
        ModalBottomSheetAction(
          title: "Camera",
          onChanged: (ctx) => pickImage(ImageSource.camera),
        ),
        ModalBottomSheetAction(
          title: "Galeria",
          onChanged: (ctx) => pickImage(ImageSource.gallery),
        ),
        ModalBottomSheetAction(
          title: "Remover",
          onChanged: (ctx) => image.value = null,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    provider = widget.pet?.image != null
        ? DioImage(Uri.parse(widget.pet!.image!))
        : null;

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
                onTap: () => _onTapImage(context),
                child: ValueListenableBuilder(
                    valueListenable: image,
                    builder: (context, value, child) {
                      provider = value != null
                          ? FileImage(File(value.path))
                          : provider;
                      return CircleAvatar(
                        radius: 102,
                        backgroundColor: Theme.of(context).dividerColor,
                        child: CircleAvatar(
                          foregroundImage: provider,
                          radius: 100,
                          child: const Icon(Icons.pets_sharp),
                        ),
                      );
                    }),
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
