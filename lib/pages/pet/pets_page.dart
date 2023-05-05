import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:propet_mobile/core/components/infinite_scroll_listview.dart';
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
  @override
  Widget build(BuildContext context) {
    return InfiniteScrollListView<Pet>(
      itemBuilder: (context, item, index) {
        return PetCardItem(
          pet: item,
        );
      },
      fetchData: (pageKey, pagingController) {
        getIt<PetService>()
            .getAllPets(pageKey)
            .then(
              (value) => {
                if (value.last)
                  pagingController.appendLastPage(value.content)
                else
                  pagingController.appendPage(value.content, pageKey + 1)
              },
            )
            .catchError((e) => {pagingController.error = e});
      },
    );
  }
}
