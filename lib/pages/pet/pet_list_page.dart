import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:propet_mobile/core/components/bottom_modal.dart';
import 'package:propet_mobile/core/components/infinite_scroll_listview.dart';
import 'package:propet_mobile/core/components/loading_dialog.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/models/pet/pet.dart';
import 'package:propet_mobile/pages/pet/pet_card_item.dart';
import 'package:propet_mobile/services/pet_service.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  final sortCriterias = [
    ModalValue(child: const Text("Nome"), value: "name"),
    ModalValue(child: const Text("Peso"), value: "weight"),
  ];
  late final PagingController<int, Pet> pagingController;
  int sortSelected = 0;

  String get order => sortCriterias[sortSelected].value;

  void onChangeSort(BuildContext context) {
    showMultiSelectBottomModal(
      context,
      MultiSelectBottomModalOptions(
        title: "Ordenar por",
        itemCount: sortCriterias.length,
        initialSelect: sortSelected,
        itemBuilder: (context, index, isSelected) {
          return ModalItem(
            isSelected: isSelected,
            child: Center(
              child: sortCriterias[index].child,
            ),
          );
        },
      ),
    ).then((value) {
      if (value != null && value != sortSelected) {
        sortSelected = value;
        pagingController.refresh();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    pagingController = PagingController(firstPageKey: 0);
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchData(int pageKey, PagingController controller) async {
    try {
      var result =
          await getIt<PetService>().getAllPets(pageIndex: pageKey, sort: order);
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/pets/edit");
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => onChangeSort(context),
                icon: const Icon(Icons.sort),
              ),
              IconButton(
                onPressed: () {
                  LoadingDialog.show(context, title: Text("Salvo"), content: Text("Pet Salvo com sucesso") , future: Future.delayed(Duration(seconds: 2)));
                },
                icon: const Icon(Icons.filter_alt),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: InfiniteScrollListView<Pet>(
                pagingController: pagingController,
                itemBuilder: (context, item, index) {
                  return Dismissible(
                    key: ValueKey(item.id),
                    child: PetCardItem(
                      pet: item,
                    ),
                  );
                },
                fetchData: (pageKey, controller) =>
                    fetchData(pageKey, controller),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
