import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:propet_mobile/core/components/divider.dart';
import 'package:propet_mobile/core/components/infinite_scroll_listview.dart';
import 'package:propet_mobile/core/components/snackbar.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/core/paging_controller.dart';
import 'package:propet_mobile/models/pet/pet.dart';
import 'package:propet_mobile/pages/pet/pet_card_item.dart';
import 'package:propet_mobile/services/pet_service.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  final _petService = getIt<PetService>();
  final _pagingController = CustomPagingController<Pet>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(
      (pageKey) async {
        try {
          var result = await _petService.getAllPets(pageIndex: pageKey);
          if (result.last) {
            _pagingController.appendLastPage(result.content);
          } else {
            _pagingController.appendPage(result.content, ++pageKey);
          }
        } catch (e) {
          _pagingController.error = e;
        }
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/pets/edit"),
        child: const Icon(Icons.add),
      ),
      body: InfiniteScrollListView<Pet>.separated(
        pagingController: _pagingController,
        separatorBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: DividerWithoutMargin(),
          );
        },
        itemBuilder: (context, item, index) =>
            _buildPetTile(item, context, index),
      ),
    );
  }

  Slidable _buildPetTile(Pet item, BuildContext context, int index) {
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Theme.of(context).colorScheme.error,
            icon: Icons.delete,
            onPressed: (_) {
              _petService.removePet(item.id).then((_) {
                _pagingController.removeAt(index);
              }).onError((error, stackTrace) {
                NotificationBar.showError(
                    context, "Error ao deletar ${item.name}!");
              }).whenComplete(() => NotificationBar.show(
                  context, "Pet ${item.name} deletado com sucesso!"));
              // pagingController.removeAt(index);
            },
          ),
        ],
      ),
      child: PetCardItem(
        pet: item,
      ),
    );
  }
}
