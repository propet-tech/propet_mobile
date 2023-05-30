import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/components/infinite_scroll_listview.dart';
import 'package:propet_mobile/core/components/loading_dialog.dart';
import 'package:propet_mobile/core/components/snackbar.dart';
import 'package:propet_mobile/core/paging_controller.dart';
import 'package:propet_mobile/models/pet/pet.dart';
import 'package:propet_mobile/pages/pet/pet_card_item.dart';
import 'package:propet_mobile/services/pet_service.dart';

class PetListPage extends StatefulWidget with GetItStatefulWidgetMixin {
  PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> with GetItStateMixin {
  late final PetService service;

  late final CustomPagingController<int, Pet> pagingController;
  int sortSelected = 0;

  void onChangeSort(BuildContext context) {
    // showMultiSelectBottomModal(
    //   context,
    //   MultiSelectBottomModalOptions(
    //     title: "Ordenar por",
    //     itemCount: sortCriterias.length,
    //     initialSelect: sortSelected,
    //     itemBuilder: (context, index, isSelected) {
    //       return ModalItem(
    //         isSelected: isSelected,
    //         child: Center(
    //           child: sortCriterias[index].child,
    //         ),
    //       );
    //     },
    //   ),
    // ).then((value) {
    //   if (value != null && value != sortSelected) {
    //     sortSelected = value;
    //     pagingController.refresh();
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    pagingController = CustomPagingController(firstPageKey: 0);
    service = get<PetService>();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchData(int pageKey, CustomPagingController controller) async {
    try {
      var result =
          await get<PetService>().getAllPets(pageIndex: pageKey, sort: null);
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
                  LoadingDialog.show(context,
                      title: Text("Salvo"),
                      content: Text("Pet Salvo com sucesso"),
                      future: Future.delayed(Duration(seconds: 2)));
                },
                icon: const Icon(Icons.filter_alt),
              ),
            ],
          ),
          Expanded(
            child: InfiniteScrollListView<Pet>(
              pagingController: pagingController,
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: Divider.createBorderSide(context),
                      ),
                    ),
                  ),
                );
              },
              itemBuilder: (context, item, index) {
                return Slidable(
                  key: ValueKey(item.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        icon: Icons.delete,
                        onPressed: (_) {
                          service.removePet(item.id).then((_) {
                            pagingController.removeAt(index);
                          }).onError((error, stackTrace) {
                            NotificationBar.showError(
                                context, "Error ao deletar ${item.name}!");
                          }).whenComplete(() => NotificationBar.show(context,
                              "Pet ${item.name} deletado com sucesso!"));
                          // pagingController.removeAt(index);
                        },
                      ),
                    ],
                  ),
                  child: PetCardItem(
                    pet: item,
                  ),
                );
              },
              fetchData: (pageKey, controller) =>
                  fetchData(pageKey, controller),
            ),
          ),
        ],
      ),
    );
  }
}
