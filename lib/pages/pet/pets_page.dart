import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:propet_mobile/core/providers.dart';
import 'package:propet_mobile/models/page.dart';
import 'package:propet_mobile/models/pet.dart';
import 'package:propet_mobile/pages/pet/pet_card_item.dart';
import 'package:propet_mobile/services/pet_service.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  late final PagingController<int, Pet> pagingController;

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) {
      getIt<PetService>().getAllPets(pageKey).then(
            (value) => {
              if (value.last)
                pagingController.appendLastPage(value.content)
              else
                pagingController.appendPage(value.content, pageKey + 1)
            },
          );
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PagedListView.separated(
        padding: const EdgeInsets.all(5),
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Pet>(
          itemBuilder: (context, item, index) => PetCardItem(pet: item),
        ),
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 5,
          );
        },
      ),
      onRefresh: () {
        return Future.sync(() => pagingController.refresh());
      },
    );
  }
}
